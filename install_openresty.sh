wget http://openresty.org/download/ngx_openresty-${NGINX_VERSION}.tar.gz && \
  tar xzvf ngx_openresty-${NGINX_VERSION}.tar.gz && \
  cd ngx_openresty-${NGINX_VERSION}/ && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  mkdir -p /etc/nginx/conf.d /etc/nginx/ssl /var/log/nginx /public && \
  rm -rf ngx_openresty-${NGINX_VERSION}*
