FROM debian:stable

MAINTAINER saksmlz@gmail.com

ENV OPENRESTY_VERSION 1.9.7.2
ENV LUAROCKS_VERSION 2.3.0
ENV NR_SDK_VERSION 0.16.2.0-beta
ENV OPENRESTY_PREFIX /opt/openresty
ENV PATH $OPENRESTY_PREFIX/bin:$OPENRESTY_PREFIX/luajit/bin:$PATH

WORKDIR /app

ADD install_openresty.sh /install_openresty.sh
ADD install_lapis.sh /install_lapis.sh
ADD install_newrelic_sdk.sh /install_newrelic_sdk.sh

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y build-essential libssl-dev libpcre3-dev zlib1g-dev perl unzip libgcc1 \
    libstdc++6 libcurl3 curl wget libc6-dev \
  && sh /install_openresty.sh \
  && sh /install_lapis.sh \
  && sh /install_newrelic_sdk.sh \
  && apt-get purge -y --auto-remove build-essential libssl-dev libpcre3-dev zlib1g-dev curl wget \
  && echo 'Yes, do as I say!' | apt-get purge --yes --force-yes --auto-remove perl perl-modules \
    manpages manpages-dev krb5-locales zip unzip linux-libc-dev libc6-dev \
  && rm -rf /var/lib/apt/lists/* /install_openresty.sh /install_lapis.sh /install_newrelic_sdk.sh

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
