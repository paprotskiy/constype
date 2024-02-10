FROM alpine:latest

ARG LUA_VER="5.4.0"
ARG LUA_ROCKS_VER="3.9.2"

# required packages to build lua and run luarocks
RUN apk add libc-dev readline readline-dev gcc make wget git

# install lua
RUN cd /tmp \
    && wget https://www.lua.org/ftp/lua-${LUA_VER}.tar.gz \
    && tar zxf lua-${LUA_VER}.tar.gz \
    && cd lua-${LUA_VER} \
    && make linux install \
    && cd /tmp \
    && rm -rf /tmp/*

# install luarocks
RUN cd /tmp \
    && wget https://luarocks.org/releases/luarocks-${LUA_ROCKS_VER}.tar.gz \
    && tar zxf luarocks-${LUA_ROCKS_VER}.tar.gz \
    && cd luarocks-${LUA_ROCKS_VER} \
    && ./configure \
    && make build \
    && make install \
    && cd /tmp \
    && rm -rf /tmp/*

COPY ./src ./src
COPY ./tests ./tests

CMD ["lua", "./tests/all.lua"]
