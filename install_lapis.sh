wget http://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz && \
  tar xzvf luarocks-${LUAROCKS_VERSION}.tar.gz && \
  cd luarocks-${LUAROCKS_VERSION} && \
  ./configure \
    --prefix=/opt/openresty/luajit/ \
    --with-lua=/opt/openresty/luajit/ \
    --lua-suffix=jit-2.1.0-beta1 \
    --with-lua-include=/opt/openresty/luajit/include/luajit-2.1/ && \
  make build && \
  make install && \
  cd .. && \
  rm -r ./luarocks-${LUAROCKS_VERSION}* && \
  /opt/openresty/luajit/bin/luarocks install lapis 1.3.1-1 && \
  /opt/openresty/luajit/bin/luarocks install busted
