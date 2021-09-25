FROM ubuntu:focal

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone\
&& apt-get update \
&& apt-get install -y build-essential clang gcc g++ nasm golang nim rustc git xz-utils zip apt-transport-https wget curl \
&& sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' \
&& sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' \
&& apt-get update \
&& apt-get install -y dart gfortran ghc fp-compiler valac libgirepository1.0-dev libglib2.0-doc gobjc gnustep-devel git \
&& ln -s /usr/lib/dart/bin/* /usr/local/bin/ \
&& mkdir -p /usr/src

WORKDIR /usr/src

RUN git clone https://github.com/oof2510/HelloWorld \
&& mkdir -p /usr/script

WORKDIR /

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
&& apt-get install -y nodejs \
&& npm i -g --force http-server

WORKDIR /usr/local/bin

RUN wget 'https://gist.githubusercontent.com/OOF2510/fa4f1d02fa96ec9c70db4299095d7f71/raw/14c804cc891f93dcc5346be1fab5af64a2245ce8/asc' \
&& chmod +x asc

WORKDIR /usr/script

RUN wget 'https://gist.githubusercontent.com/OOF2510/dccdb0f47e1fe2022e29601931da70a5/raw/a38f291fc686453f8233876df9b1fee3c76a75ae/compile.sh'
EXPOSE 8080

CMD ["bash", "compile.sh"]
