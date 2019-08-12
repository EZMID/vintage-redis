#!/usr/bin/make -f

# RUN WHOLE PROCESS IN ONE SHELL
.ONESHELL:

################################################################################
################################################################################
# Variable definitions
################################################################################

# Are we running in an interactive shell? If so then we can use codes for
# a colored output
ifeq ("$(shell [ -t 0 ] && echo yes)","yes")
FORMAT_BOLD=\e[1m
FORMAT_RED=\033[0;31m
FORMAT_YELLOW=\033[0;33m
FORMAT_GREEN=\x1b[32;01m
FORMAT_RESET=\033[0m
else
FORMAT_BOLD=
FORMAT_RED=
FORMAT_YELLOW=
FORMAT_GREEN=
FORMAT_RESET=
endif

# Platform fixes
ECHO=$(shell which echo)
OSECHOFLAG=-e
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	ECHO=echo
	OSECHOFLAG=
	FORMAT_BOLD=
endif

# Echo binary
ECHO=$(shell which echo)

################################################################################
# Specific project variables
################################################################################
DOCKERFILE=4.0.Dockerfile
REGISTRY=
NAMESPACE=ezmid
IMAGE=redis
TAG=4.0
VERSION=latest

################################################################################
# Manual
.ONESHELL: default
.PHONY: default
default: 
	@$(ECHO) -e "\n$(FORMAT_BOLD)VINTAGE MAKE TOOL$(FORMAT_RESET)\n" \
	"\n" \
	"$(FORMAT_YELLOW)Variables:$(FORMAT_RESET)\n" \
	"  REGISTRY:                    $(REGISTRY)\n" \
	"  NAMESPACE:                   $(NAMESPACE)\n" \
	"  IMAGE:                       $(IMAGE)\n" \
	"  TAG:                         $(TAG)\n" \
	"\n" \
	"$(FORMAT_YELLOW)Commands:$(FORMAT_RESET)\n" \
	"  make build                   Build the image\n" \
	"  make build TAG=1.1.0         Build a specific version of the image\n" \
	"  make test                    Test the image with Goss\n" \
	"  make test TAG=1.1.0          Test a specific version of the image with Goss\n" \
	"  make push                    Push the image to the registry\n" \
	"  make push TAG=1.1.0          Push a specific version of the image to the registry\n" \
	"\n"

################################################################################
# Build/rebuild the image
.PHONY: build
.ONESHELL: build
build: build/all

# Build/rebuild all images
.PHONY: build/all
build/all:
	docker build . -t $(NAMESPACE)/$(IMAGE):4.0-$(VERSION) -f 4.0.Dockerfile --no-cache
	docker build . -t $(NAMESPACE)/$(IMAGE):5.0-$(VERSION) -f 5.0.Dockerfile --no-cache

# Redis 4.0
.PHONY: build/4.0
build/4.0:
	docker build . -t $(NAMESPACE)/$(IMAGE):4.0-$(VERSION) -f 4.0.Dockerfile --no-cache

# Redis 5.0
.PHONY: build/5.0
build/5.0:
	docker build . -t $(NAMESPACE)/$(IMAGE):5.0-$(VERSION) -f 5.0.Dockerfile --no-cache


################################################################################
# Push the image to registry
.PHONY: push
push/: push/all

.PHONY: push/all
push/all:
	docker push $(NAMESPACE)/$(IMAGE):4.0-$(VERSION)
	docker push $(NAMESPACE)/$(IMAGE):5.0-$(VERSION)

.PHONY: push/4.0
push/4.0:
	docker push $(NAMESPACE)/$(IMAGE):4.0-$(VERSION)

.PHONY: push/5.0
push/5.0:
	docker push $(NAMESPACE)/$(IMAGE):5.0-$(VERSION)

################################################################################
# Run all tests
.PHONY: test
.ONESHELL: test
test: test/all

.PHONY: test/all
test/all:
	make test/4.0
	make test/5.0

# Test Redis 4.0 image
.PHONY: test/4.0
test/4.0:
	rm -f goss.yaml
	cp 4.0.goss.yaml goss.yaml
	dgoss run $(NAMESPACE)/$(IMAGE):4.0-$(VERSION)

# Test Redis 5.0 image
.PHONY: test/5.0
test/5.0:
	rm -f goss.yaml
	cp 5.0.goss.yaml goss.yaml
	dgoss run $(NAMESPACE)/$(IMAGE):5.0-$(VERSION)
	