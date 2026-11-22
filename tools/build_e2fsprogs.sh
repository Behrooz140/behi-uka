#!/bin/bash
# Build static ARM64 e2fsprogs 1.47.4 (e2fsck, mke2fs, resize2fs, tune2fs).
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
BUILD="/root/uka_build"
OUT="$HERE/bin"
J="$(nproc)"
mkdir -p "$BUILD" "$OUT"
if [ ! -f "$BUILD/v1.47.4.tar.gz" ]; then
  cp "$HERE/src/v1.47.4.tar.gz" "$BUILD/"
fi

echo "== e2fsprogs 1.47.4"
rm -rf "$BUILD/e2fsprogs-src"
tar xf "$BUILD/v1.47.4.tar.gz" -C "$BUILD"
mv "$BUILD"/e2fsprogs-1.47.4 "$BUILD/e2fsprogs-src"
cd "$BUILD/e2fsprogs-src"
./configure --disable-shared --enable-static --disable-nls --disable-tls \
  CFLAGS="-O2" LDFLAGS="-static" > "$BUILD/e2fs-configure.log" 2>&1 || {
    tail -30 "$BUILD/e2fs-configure.log"; exit 1; }
make -j"$J" > "$BUILD/e2fs-make.log" 2>&1 || {
    tail -40 "$BUILD/e2fs-make.log"; exit 1; }

for t in e2fsck mke2fs resize2fs tune2fs; do
  src="misc/$t"
  [ -x "$src" ] || src="e2fsck/$t"
  if [ -x "$src" ]; then
    cp "$src" "$OUT/$t"
    echo "  -> $t"
  else
    echo "  !! missing $t"
  fi
done
