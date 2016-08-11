#!/bin/sh

set -ex \
  && wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz \
  && tar xzvf luarocks-${LUAROCKS_VERSION}.tar.gz \
  && cd luarocks-${LUAROCKS_VERSION} \
  && ./configure \
    --prefix=${OPENRESTY_PREFIX}/luajit/ \
    --with-lua=${OPENRESTY_PREFIX}/luajit/ \
    --lua-suffix=jit-2.1.0-beta2 \
    --with-lua-include=${OPENRESTY_PREFIX}/luajit/include/luajit-2.1/ \
  && make build \
  && make install \
  && cd .. \
  && rm -r ./luarocks-${LUAROCKS_VERSION}* \
  && luarocks install luasec \
  && luarocks install lapis \
  && luarocks install resty-newrelic \
  && luarocks install lua-resty-http \
  && luarocks install lustache \
  && luarocks install net-url \
  && luarocks install inspect \
  && luarocks install busted \
  && ln -sf /opt/openresty/lualib/cjson.so `find /opt/openresty/luajit/lib/ -name cjson.so`
