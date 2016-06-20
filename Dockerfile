FROM alpine:latest

MAINTAINER saksmlz@gmail.com

ENV OPENRESTY_VERSION 1.9.3.1
ENV LUAROCKS_VERSION 2.2.2
ENV NR_SDK_VERSION 0.16.2.0-beta
ENV OPENRESTY_PREFIX /opt/openresty
ENV PATH $OPENRESTY_PREFIX/bin:$OPENRESTY_PREFIX/luajit/bin:$PATH

WORKDIR /app

ADD install_openresty.sh /install_openresty.sh
ADD install_lapis.sh /install_lapis.sh
ADD install_newrelic_sdk.sh /install_newrelic_sdk.sh

RUN \
      addgroup -S nginx \
      && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
      && apk --update add build-base openssl-dev pcre pcre-dev zlib-dev perl wget unzip libgcc \
        musl-utils libssl1.0 libcrypto1.0 zlib alpine-baselayout libstdc++ libc6-compat curl \

      && sh /install_openresty.sh \
      && sh /install_lapis.sh
RUN \
  sh /install_newrelic_sdk.sh \
  && apk add git \
  && /opt/openresty/luajit/bin/luarocks install resty-newrelic


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
