FROM alpine:latest

ENV NGINX_VERSION 1.7.10.2
ENV LUAROCKS_VERSION 2.2.2
ENV OPENRESTY_PREFIX /opt/openresty
ENV PATH $OPENRESTY_PREFIX/bin:$OPENRESTY_PREFIX/luajit/bin:$PATH

WORKDIR /app

ADD install_openresty.sh /install_openresty.sh
ADD install_lapis.sh /install_lapis.sh

RUN apk --update add build-base openssl-dev pcre-dev zlib-dev perl wget unzip && \

  sh /install_openresty.sh && \
  sh /install_lapis.sh && \

  # cleanup
  apk del build-base perl unzip wget openssl-dev openssl-doc zlib-dev && \
  rm -rf /var/cache/apk/* && \
  rm /install_openresty.sh /install_lapis.sh

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
