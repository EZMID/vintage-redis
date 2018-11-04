FROM alpine:3.8

MAINTAINER Filip Cieker <filip.cieker@ezmid.com>
LABEL maintainer="Filip Cieker filip.cieker@ezmid.com"

################################################################################
# Layer 1 - Add the Redis package
RUN apk --no-cache add \
    redis

################################################################################
# Layer 2 - Copy default configuration
COPY ./docker/ /

################################################################################
# Init system - Run without password protection (only for dev purposes)
USER redis
EXPOSE 6379
ENTRYPOINT ["redis-server", "--protected-mode", "no"]
