FROM debian:bookworm AS libwallabybuild

ARG VERSION
ENV LIB_VERSION=${VERSION}

# prepare OS
RUN export DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture arm64
## Base Packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y git cmake make gcc curl wget build-essential ca-certificates gcc-aarch64-linux-gnu g++-aarch64-linux-gnu file binfmt-support qemu-user-binfmt qemu-user-static
## Dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y swig python3 python3-dev x11proto-dev libx11-dev libx11-dev:arm64 libzbar-dev:arm64 libopencv-dev:arm64 libjpeg-dev:arm64 

# Compile libwallaby

## libwallaby (see https://github.com/kipr/libwallaby)
WORKDIR /opt/libwallaby
COPY . .

## Prepare Build Dir
WORKDIR /opt/libwallaby/build
### do it
RUN cmake -Wno-dev -Dwith_documentation=OFF -Dwith_tests=OFF -DCMAKE_TOOLCHAIN_FILE=/opt/libwallaby/toolchain/aarch64-linux-gnu.cmake ..
RUN make -j$(nproc)

# output build results
RUN make package

# clean image
RUN apt-get autoremove -y && apt-get autoclean -y


FROM docker.io/debian:bookworm-slim AS libwallabyout

LABEL authors="Team Free2Pay <jakob.kampichler+ftplib@robo4you.at>"

WORKDIR /opt
RUN mkdir -p out
COPY --from=libwallabybuild /opt/libwallaby/build/. ./out/.

# create output script
# copies ftplib build/ to $1
RUN <<EOF cat >> /opt/out.sh
#!/bin/bash
cp -r /opt/out/. \$1/.
EOF
RUN chmod +x /opt/out.sh


ENTRYPOINT ["/opt/out.sh"]
