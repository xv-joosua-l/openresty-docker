wget http://openresty.org/download/ngx_openresty-${NGINX_VERSION}.tar.gz && \
  tar xzvf ngx_openresty-${NGINX_VERSION}.tar.gz && \
  cd ngx_openresty-${NGINX_VERSION}/ && \
  ./configure -j4 \
    --prefix=$OPENRESTY_PREFIX \
    --sbin-path=/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --lock-path=/var/run/nginx.lock \
    --pid-path=/var/run/nginx.pid \
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
  rm -rf ngx_openresty-${NGINX_VERSION}*
