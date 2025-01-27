FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    make \
    cmake \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    doxygen \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 -U -s /bin/bash kipr
WORKDIR /home/kipr

USER kipr
COPY . .

RUN cmake -Bbuild -DCMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain/arm-linux-gnueabihf.cmake . 

WORKDIR /home/kipr/build

RUN make package

ENTRYPOINT [ "/usr/bin/cat", "/home/kipr/build/*-Linux.deb" ]