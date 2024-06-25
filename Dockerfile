FROM caddy:2.8.4-builder AS builder-caddy

RUN xcaddy build \
  --with github.com/caddy-dns/cloudflare@d11ac0bfeab7475d8b89e2dc93f8c7a8b8859b8f
  

FROM alpine as builder-alist

WORKDIR /app/
RUN apk add --no-cache bash curl gcc git go musl-dev
COPY ./upstream-repo/go.mod ./upstream-repo/go.sum ./
RUN go mod download
COPY ./upstream-repo ./
RUN bash build.sh release docker


FROM alpine AS dist

COPY ./content /workdir/

ARG TARGETPLATFORM

ENV CADDY_DOMAIN=http://localhost
ENV CADDY_EMAIL=internal
ENV CADDY_WEB_PORT=8080
ENV ALIST_PORT=61600
ENV ARIA2_PORT=61601
ENV QBT_WEBUI_PORT=61602
ENV ARIA2_TRACKER_UPDATE=enable

RUN apk add --no-cache --update curl runit tzdata \
    && wget -O - https://github.com/mayswind/AriaNg/releases/download/1.3.6/AriaNg-1.3.6.zip | busybox unzip -qd /workdir/ariang - \
    && wget -O - https://github.com/WDaan/VueTorrent/releases/latest/download/vuetorrent.zip | busybox unzip -qd /workdir - \
    && wget -O - https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip | busybox unzip -qd /workdir/homer - \
    && cp /workdir/homer_conf/* /workdir/homer/assets/tools/ \
    && mv /workdir/homer_conf/homer.yml /workdir/homer/assets/config.yml \
    && sh /workdir/install.sh \
    && rm -r /workdir/install.sh /workdir/homer_conf \
    && chmod +x /workdir/service/*/run /workdir/service/*/log/run \
    && ln -s /workdir/service/* /etc/service/

COPY --from=builder-caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=builder-alist /app/bin/alist /usr/bin/

ENTRYPOINT ["runsvdir","/etc/service"]
