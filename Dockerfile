FROM alpine:3.8

MAINTAINER Filip Cieker <filip.cieker@ezmid.com>

RUN apk --no-cache add \
    redis

COPY ./docker/ /

USER redis

EXPOSE 6379

# ENTRYPOINT ["redis-server", "/etc/redis.conf"]
ENTRYPOINT ["redis-server", "--protected-mode", "no"]
