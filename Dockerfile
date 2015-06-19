FROM debian:wheezy

ENV NGINX_VERSION 1.7.10.1

RUN apt-get update && \
  apt-get install -y wget libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential && \
  wget http://openresty.org/download/ngx_openresty-${NGINX_VERSION}.tar.gz && \
  tar xzvf ngx_openresty-${NGINX_VERSION}.tar.gz && \
  cd ngx_openresty-${NGINX_VERSION}/ && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  mkdir -p /etc/nginx/conf.d /etc/nginx/ssl /var/log/nginx /public && \
  rm -rf ngx_openresty-${NGINX_VERSION}* && \
  apt-get remove -y wget libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential && \
  apt-get install -y zlib1g openssl ca-certificates libpcre3 perl-modules && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/sbin/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
