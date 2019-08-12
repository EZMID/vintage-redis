FROM alpine:3.9

LABEL maintainer="Filip Cieker filip.cieker@ezmid.com"

################################################################################
# Layer 1 - Add the Redis package
RUN apk --no-cache --update upgrade && \
    apk add \
    redis

################################################################################
# Layer 2 - Copy default configuration
COPY ./docker/ /

################################################################################
# Init system - Run without password protection (only for dev purposes)
USER redis
EXPOSE 6379
ENTRYPOINT ["redis-server", "--protected-mode", "no"]
