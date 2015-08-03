FROM debian:jessie

ENV NGINX_VERSION 1.7.10.2
ENV LUAROCKS_VERSION 2.2.2

WORKDIR /app

ADD install_openresty.sh /install_openresty.sh
ADD install_lapis.sh /install_lapis.sh

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y wget unzip libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential && \

  bash /install_openresty.sh && \
  bash /install_lapis.sh && \

  # cleanup
  apt-get remove -y wget unzip libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential && \
  apt-get install -y zlib1g openssl ca-certificates libpcre3 perl-modules && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm /install_openresty.sh /install_lapis.sh

RUN ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/sbin/nginx

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
