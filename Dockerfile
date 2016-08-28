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

WORKDIR /app

ENV \
  OPENRESTY_VERSION=1.11.2.1 \
  LUAROCKS_VERSION=2.3.0 \
  OPENRESTY_PREFIX=/opt/openresty \
  NGX_CACHE_DIR=/var/cache/nginx

ENV PATH=$OPENRESTY_PREFIX/bin:$OPENRESTY_PREFIX/luajit/bin:$PATH

ADD install_openresty.sh /install_openresty.sh
ADD install_luarocks.sh /install_luarocks.sh

RUN set -ex \
      && apt-get update \
      && apt-get upgrade --yes \
      && apt-get install --yes \
        ca-certificates \
        build-essential \
        curl \
        git \
        libc6-dev \
        libcurl3 \
        libgcc1 \
        libpcre3-dev \
        libssl-dev \
        libstdc++6 \
        perl \
        unzip \
        wget \
        zlib1g-dev \
      && /install_openresty.sh \
      && /install_luarocks.sh \
      && apt-get purge --yes --auto-remove \
        build-essential \
        curl \
        git \
        iproute \
        libgssapi-krb5-2 \
        libidn11 \
        libk5crypto3 \
        libkeyutils1 \
        libkrb5-3 \
        libkrb5support0 \
        libpcre3-dev \
        libssh2-1 \
        libssl-dev \
        rename \
        wget \
        zlib1g-dev \
      && echo 'Yes, do as I say!' | apt-get purge --yes --force-yes --auto-remove \
        manpages \
        manpages-dev \
        krb5-locales \
        unzip \
        linux-libc-dev \
        libc6-dev \
      && rm -rf \
        /var/lib/apt/lists/* \
        /install_openresty.sh \
        /install_luarocks.sh

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
