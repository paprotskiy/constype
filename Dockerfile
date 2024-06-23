FROM alpine:latest as constype-app

ARG LUA_VER="5.4.0"
ARG LUA_ROCKS_VER="3.9.2"

RUN apk add            \
    ncurses            \
    libc-dev           \
    openssl-dev        \
    libffi-dev         \
    gnu-libiconv       \
    gnu-libiconv-dev   \
    readline           \
    readline-dev       \
    gcc                \
    make               \
    wget               \
    git
                       
RUN cd /tmp \
    && wget https://www.lua.org/ftp/lua-${LUA_VER}.tar.gz \
    && tar zxf lua-${LUA_VER}.tar.gz \
    && cd lua-${LUA_VER} \
    && make linux install \
    && cd /tmp \
    && rm -rf /tmp/*

RUN cd /tmp \
    && wget https://luarocks.org/releases/luarocks-${LUA_ROCKS_VER}.tar.gz \
    && tar zxf luarocks-${LUA_ROCKS_VER}.tar.gz \
    && cd luarocks-${LUA_ROCKS_VER} \
    && ./configure \
    && make build \
    && make install \
    && cd /tmp \
    && rm -rf /tmp/*

RUN luarocks install --server=https://luarocks.org/dev lua-hashings \
    && luarocks install lua-cjson       \
    && luarocks install lua-term        \
    && luarocks install luasocket       \
    && luarocks install luaposix        \
    && luarocks install lua-iconv       \
    && luarocks install luasec          \
    && luarocks install luaossl         \
    && luarocks install pgmoon   

COPY ./src ./src
