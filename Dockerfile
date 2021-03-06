FROM alpine:latest

ADD entrypoint.sh /

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && apk update \
    && apk --no-cache add \
    openfortivpn openssl grep sed iptables \
    && chmod +x entrypoint.sh

ENV HOST=host
ENV PORT=443
ENV USER=user
ENV PASS=pass
ENV INTERVAL=3
ENV REALM=/

ENTRYPOINT [ "/entrypoint.sh" ]