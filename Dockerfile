FROM debian:stable

MAINTAINER saksmlz@gmail.com

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r nginx && useradd -r -g nginx nginx

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
  && apt-get update && apt-get install -y wget ca-certificates --no-install-recommends \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
  && gosu nobody true \
  && apt-get purge -y --auto-remove wget ca-certificates \
  && rm -rf /var/lib/apt/lists/*

ENV OPENRESTY_VERSION 1.9.15.1rc2
ENV LUAROCKS_VERSION 2.3.0
ENV NR_SDK_VERSION 0.16.2.0-beta
ENV OPENRESTY_PREFIX /opt/openresty
ENV PATH $OPENRESTY_PREFIX/bin:$OPENRESTY_PREFIX/luajit/bin:$PATH

WORKDIR /app

ADD install_openresty.sh /install_openresty.sh
ADD install_lapis.sh /install_lapis.sh
ADD install_newrelic_sdk.sh /install_newrelic_sdk.sh

RUN set -x \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y build-essential libssl-dev libpcre3-dev zlib1g-dev perl unzip libgcc1 \
    libstdc++6 libcurl3 curl wget libc6-dev git \
  && sh /install_openresty.sh \
  && sh /install_lapis.sh \
  && sh /install_newrelic_sdk.sh \
  && apt-get purge -y --auto-remove build-essential libssl-dev libpcre3-dev zlib1g-dev curl wget git \
  && echo 'Yes, do as I say!' | apt-get purge --yes --force-yes --auto-remove perl perl-modules \
    manpages manpages-dev krb5-locales zip unzip linux-libc-dev libc6-dev \
  && rm -rf /var/lib/apt/lists/* /install_openresty.sh /install_lapis.sh /install_newrelic_sdk.sh

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
