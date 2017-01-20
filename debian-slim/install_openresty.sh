#!/bin/sh

set -ex \
  && curl -L https://github.com/maxmind/libmaxminddb/releases/download/1.2.0/libmaxminddb-1.2.0.tar.gz | tar -xzv -C /opt \
  && cd /opt/libmaxminddb-1.2.0 \
  && ./configure \
  && make -j8 \
  && make install \
  && ldconfig \
  && rm -rf /opt/libmaxminddb-1.2.0/

set -ex \
  && curl -L https://github.com/leev/ngx_http_geoip2_module/archive/2.0.tar.gz | tar -xzv -C /opt \

set -ex \
  && curl -L https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz | tar -xzv -C /opt \
  && cd /opt/openresty-${OPENRESTY_VERSION}/ \
  && ./configure -j8 \
    --prefix=${OPENRESTY_PREFIX} \
    --sbin-path=/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --lock-path=/var/run/nginx.lock \
    --pid-path=/var/run/nginx.pid \
    --user=nginx \
    --group=nginx \
    --http-client-body-temp-path=${NGX_CACHE_DIR}/client_temp \
    --http-proxy-temp-path=${NGX_CACHE_DIR}/proxy_temp \
    --http-fastcgi-temp-path=${NGX_CACHE_DIR}/fastcgi_temp \
    --http-uwsgi-temp-path=${NGX_CACHE_DIR}/uwsgi_temp \
    --http-scgi-temp-path=${NGX_CACHE_DIR}/scgi_temp \
    --without-http_fastcgi_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --add-module=/opt/ngx_http_geoip2_module-2.0 \
  && make -j8 \
  && make install \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && mkdir -p \
    ${NGX_CACHE_DIR}/proxy_temp \
    ${NGX_CACHE_DIR}/client_temp \
    ${NGX_CACHE_DIR}/proxy_temp \
    ${NGX_CACHE_DIR}/fastcgi_temp \
    ${NGX_CACHE_DIR}/uwsgi_temp \
    ${NGX_CACHE_DIR}/scgi_temp \
  && echo "#!/usr/bin/env resty" > /usr/local/bin/resty-busted \
  && echo "require 'busted.runner'({ standalone = false })" >> /usr/local/bin/resty-busted \
  && chmod +x /usr/local/bin/resty-busted \
  && rm -rf /opt/openresty-${OPENRESTY_VERSION}/ \
  && rm -rf /opt/ngx_http_geoip2_module-2.0/
