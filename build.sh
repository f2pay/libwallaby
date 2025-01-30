#!/bin/bash

set -euo pipefail

VER=$(git rev-parse --short HEAD)
echo "Building libwallaby_compiler:$VER"

sudo docker buildx build --load \
  --build-arg VERSION=$VER \
  -t libwallaby_compiler:$VER \
  .

OUT_DIR="./build-libwallaby"

for arg in "$@"; do
    # Check if the argument matches the expected pattern
    if [[ "$arg" == --out=* ]]; then
        # Extract the value after the '='
        OUT_DIR="${arg#*=}"
        break
    fi
done

mkdir -p $OUT_DIR
sudo docker run --rm -v $OUT_DIR:/data libwallaby_compiler:$VER /data

echo "libwallaby build output should be in $OUT_DIR!"
