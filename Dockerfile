FROM debian:stable

MAINTAINER saksmlz@gmail.com

ENV OPENRESTY_VERSION 1.9.3.1
ENV LUAROCKS_VERSION 2.2.2
ENV OPENRESTY_PREFIX /opt/openresty
ENV PATH $OPENRESTY_PREFIX/bin:$OPENRESTY_PREFIX/luajit/bin:$PATH

WORKDIR /app

ADD install_openresty.sh /install_openresty.sh
ADD install_lapis.sh /install_lapis.sh

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y build-essential libssl-dev libpcre3-dev zlib1g-dev perl unzip libgcc1 libstdc++6 libcurl3 curl wget libc6-dev \
  && sh /install_openresty.sh \
  && sh /install_lapis.sh \
  && apt-get purge -y --auto-remove build-essential libssl-dev libpcre3-dev zlib1g-dev curl wget \
    binutils bzip2 cpp cpp-4.9 dpkg-dev fakeroot g++ g++-4.9 gcc gcc-4.9 libalgorithm-diff-perl \
    libalgorithm-diff-xs-perl libalgorithm-merge-perl libasan1 libatomic1 libcilkrts5 libcloog-isl4 \
    libdpkg-perl libfakeroot libfile-fcntllock-perl libgcc-4.9-dev libgomp1 libicu52 libisl10 libitm1 \
    liblsan0 libmpc3 libmpfr4 libpcrecpp0 libpsl0 libquadmath0 libssl-doc libstdc++-4.9-dev
    libtimedate-perl libtsan0 libubsan0 make patch xz-utils \
  && rm -rf /var/lib/apt/lists/* /install_openresty.sh /install_lapis.sh
# echo 'Yes, do as I say!' | apt-get purge -y --force-yes manpages manpages-dev krb5-locales perl systemd


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
