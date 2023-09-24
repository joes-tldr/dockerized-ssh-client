FROM alpine:latest

RUN set -xv; \
    apk add --update bash openssh-client sshpass netcat-openbsd && \
    rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

RUN set -xv; \
    chmod 500 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
