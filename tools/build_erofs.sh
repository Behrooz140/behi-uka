#!/bin/bash
# Build static ARM64 erofs-utils 1.9.4 (dump.erofs, fsck.erofs only).
# mkfs.erofs / extract.erofs stay untouched: UKA uses a custom fork with --product-out.
set -uo pipefail
BUILD="/root/uka_build"
OUT="$(cd "$(dirname "$0")/bin" && pwd)"
J="$(nproc)"
cd "$BUILD/erofs-utils-1.9.4"
./autogen.sh > "$BUILD/erofs-autogen.log" 2>&1 || { tail -20 "$BUILD/erofs-autogen.log"; exit 1; }
./configure --disable-shared --enable-static --disable-fuse \
  --without-lzma --with-libzstd --with-lz4 \
  --without-libxml2 --without-libcurl --without-json-c --without-uuid \
  CFLAGS="-O2 -static" LDFLAGS="-static" PKG_CONFIG="pkg-config --static" \
  > "$BUILD/erofs-configure.log" 2>&1 || {
    tail -30 "$BUILD/erofs-configure.log"; exit 1; }
make -j"$J" LDFLAGS="-all-static" > "$BUILD/erofs-make.log" 2>&1 || { tail -40 "$BUILD/erofs-make.log"; exit 1; }

for t in dump/dump.erofs fsck/fsck.erofs; do
  if [ -x "$t" ]; then
    cp "$t" "$OUT/$(basename "$t")"
    echo "  -> $(basename "$t")"
  fi
done
