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
&& mkdir -p /usr/src \
&& mkdir -p /usr/downloads

WORKDIR /usr/downloads

RUN wget https://swiftlang.xyz/ubuntu/pool/main/s/swiftlang/swiftlang_5.4.3-01-ubuntu-focal_amd64.deb \
&& apt-get install -y ./swiftlang_5.4.3-01-ubuntu-focal_amd64.deb

WORKDIR /usr/src

RUN git clone https://github.com/oof2510/HelloWorld \
&& mkdir -p /usr/script

WORKDIR /

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
&& apt-get install -y nodejs \
&& npm i -g --force http-server

WORKDIR /usr/script

RUN echo "#!/usr/bin/env bash\ncd /usr/src/HelloWorld && git pull && g++ -c c++/HelloWorld.cpp && g++ -o HelloWorld-cpp-linux-x64 HelloWorld.o && gcc c/HelloWorld.c -o HelloWorld-c-linux-x64 && go build golang/helloWorld.go && mv helloWorld helloWorld-go-linux-x64 && rustc rust/helloWorld.rs -o helloWorld-rust-linux-x64 && nasm -f elf64 -o helloworld.o assembly/helloworld-linux-x64.S && ld -o helloworld-assembly-linux-x64 helloworld.o && dart compile exe dart/hello_world.dart -o hello_world-dart-linux-x64 && gfortran fortran/helloworld.f90 -o helloworld-fortran-linux-x64 && ghc haskell/helloworld.hs -o helloworld-haskell-linux-x64 && nim compile nim/helloWorld.nim && mv nim/helloWorld helloWorld-nim-linux-x64 && pc pascal/HelloWorld.pas && mv pascal/HelloWorld HelloWorld-pascal-linux-x64 && valac vala/HelloWorld.vala -o HelloWorld-vala-linux-x64 && gcc objective-c/HelloWorld.m `gnustep-config --objc-flags` `gnustep-config --base-libs` -o HelloWorld-objective_c-linux-x64 && swiftc swift/helloWorld.swift -o helloWorld-swift-linux-x64 && rm **/*.o **/*.hi *.o *.d && mkdir dist && mv hello* Hello* dist/ && http-server ./dist -p 8080" > compile.bash
EXPOSE 8080

CMD ["bash", "compile.bash"]