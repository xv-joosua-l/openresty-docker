#!/bin/sh

set -ex \
  && wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz \
  && tar xzvf luarocks-${LUAROCKS_VERSION}.tar.gz \
  && cd luarocks-${LUAROCKS_VERSION} \
  && ./configure \
    --prefix=${OPENRESTY_PREFIX}/luajit \
    --with-lua-bin=${OPENRESTY_PREFIX}/luajit/bin \
    --lua-suffix=jit-2.1.0-beta3 \
    --with-lua-include=${OPENRESTY_PREFIX}/luajit/include/luajit-2.1 \
  && make build \
  && make install \
  && cd .. \
  && rm -r ./luarocks-${LUAROCKS_VERSION}*
