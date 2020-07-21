FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y mono-devel
RUN apt-get install -y openjdk-11-jdk
RUN apt-get install -y g++
RUN apt-get install -y python3 python-is-python3
RUN apt-get install -y php php-mbstring
RUN apt-get install -y lua5.1 luarocks
RUN luarocks install luautf8 && luarocks install bit32
ADD https://deb.nodesource.com/setup_14.x /opt/setup_node_14.x
RUN bash /opt/setup_node_14.x
RUN apt-get install -y nodejs
RUN npm install --global lix

WORKDIR /opt/unifill

ADD .haxerc /opt/unifill/.haxerc
ADD haxe_libraries /opt/unifill/haxe_libraries
RUN lix download

ADD . /opt/unifill
