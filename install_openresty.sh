wget http://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz && \
  tar xzvf ngx_openresty-${OPENRESTY_VERSION}.tar.gz && \
  cd ngx_openresty-${OPENRESTY_VERSION}/ && \
  ./configure -j4 \
    --prefix=$OPENRESTY_PREFIX \
    --sbin-path=/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --lock-path=/var/run/nginx.lock \
    --pid-path=/var/run/nginx.pid \
    --http-client-body-temp-path=$NGX_CACHE_DIR/client_temp \
    --http-proxy-temp-path=$NGX_CACHE_DIR/proxy_temp \
    --http-fastcgi-temp-path=$NGX_CACHE_DIR/fastcgi_temp \
    --http-uwsgi-temp-path=$NGX_CACHE_DIR/uwsgi_temp \
    --http-scgi-temp-path=$NGX_CACHE_DIR/scgi_temp \
    --without-http_fastcgi_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    && \
  make -j4 && \
  mkdir -p /etc/nginx/ && \
  make install && \
  cd .. && \
  rm -rf ngx_openresty-${OPENRESTY_VERSION}*
