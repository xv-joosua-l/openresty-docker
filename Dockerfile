FROM alpine:latest

MAINTAINER saksmlz@gmail.com

ENV NGINX_VERSION 1.7.10.2
ENV LUAROCKS_VERSION 2.2.2
ENV OPENRESTY_PREFIX /opt/openresty
ENV PATH $OPENRESTY_PREFIX/bin:$OPENRESTY_PREFIX/luajit/bin:$PATH

WORKDIR /app

ADD install_openresty.sh /install_openresty.sh
ADD install_lapis.sh /install_lapis.sh

RUN apk --update add build-base openssl-dev pcre pcre-dev zlib-dev perl wget unzip libgcc \
  musl-utils libssl1.0 libcrypto1.0 zlib alpine-baselayout && \

  sh /install_openresty.sh && \
  sh /install_lapis.sh && \

  # cleanup
  apk del build-base perl unzip wget openssl-dev openssl-doc zlib-dev pcre-dev alpine-base apk-tools && \
  rm -rf /var/cache/apk/* /install_openresty.sh /install_lapis.sh

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
