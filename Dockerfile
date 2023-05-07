FROM caddy:2.6.4-builder AS builder-caddy

RUN xcaddy build \
  --with github.com/caddy-dns/cloudflare


FROM alpine AS dist

COPY ./content /workdir/

ENV CADDY_DOMAIN=http://localhost
ENV CADDY_EMAIL=internal
ENV CADDY_WEB_PORT=8080
ENV ALIST_PORT=61600
ENV ARIA2_PORT=61601
ENV QBT_WEBUI_PORT=61602
ENV ARIA2_TRACKER_UPDATE=enable

RUN apk add --no-cache --update curl runit tzdata \
    && wget -O - https://github.com/mayswind/AriaNg/releases/download/1.3.4/AriaNg-1.3.4.zip | busybox unzip -qd /workdir/ariang - \
    && wget -O - https://github.com/WDaan/VueTorrent/releases/latest/download/vuetorrent.zip | busybox unzip -qd /workdir - \
    && sh /workdir/install.sh \
    && rm /workdir/install.sh \
    && chmod +x /workdir/service/*/run /workdir/service/*/log/run \
    && ln -s /workdir/service/* /etc/service/

COPY --from=builder-caddy /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["runsvdir","/etc/service"]
