FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:haxe/releases \
    && apt-get update \
    && apt-get install -y \
        php php-mbstring \
        python3 python-is-python3 \
        lua5.1 luarocks \
        haxe \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN luarocks install luautf8 && luarocks install bit32

RUN mkdir /opt/haxelib \
    && haxelib setup /opt/haxelib \
    && haxelib install hx3compat

ADD https://deb.nodesource.com/setup_14.x /opt/setup_node_14.x

RUN bash /opt/setup_node_14.x && apt-get install -y nodejs

ADD . /opt/unifill

WORKDIR /opt/unifill

