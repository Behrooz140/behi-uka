#!/bin/bash
# Build newer static ARM64 replacements for upstream compressors + file.
# Build happens in /root/uka_build (path without spaces — libtool requires this).
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRCPKG="$HERE/src"
BUILD="/root/uka_build"
OUT="$HERE/bin"
J="$(nproc)"
mkdir -p "$BUILD" "$OUT"
cp -n "$SRCPKG"/*.tar.gz "$BUILD/" 2>/dev/null || true

build_zstd() {
  echo "== zstd 1.5.7"
  rm -rf "$BUILD/zstd-src" "$BUILD/zstd-build"
  tar xf "$BUILD/zstd-1.5.7.tar.gz" -C "$BUILD" && mv "$BUILD/zstd-1.5.7" "$BUILD/zstd-src"
  cmake -S "$BUILD/zstd-src/build/cmake" -B "$BUILD/zstd-build" \
    -DBUILD_SHARED_LIBS=OFF -DZSTD_BUILD_SHARED=OFF -DZSTD_BUILD_STATIC=ON \
    -DZSTD_BUILD_PROGRAMS=ON -DCMAKE_EXE_LINKER_FLAGS=-static >/dev/null 2>&1 \
    && cmake --build "$BUILD/zstd-build" --target zstd -j"$J" >/dev/null 2>&1 \
    && cp "$BUILD/zstd-build/programs/zstd" "$OUT/zstd64"
}

build_lz4() {
  echo "== lz4 1.11.1"
  rm -rf "$BUILD/lz4-src" "$BUILD/lz4-build"
  tar xf "$BUILD/lz4-1.11.1.tar.gz" -C "$BUILD" && mv "$BUILD/lz4-1.11.1" "$BUILD/lz4-src"
  cmake -S "$BUILD/lz4-src/build/cmake" -B "$BUILD/lz4-build" \
    -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS=-static >/dev/null 2>&1 \
    && cmake --build "$BUILD/lz4-build" --target lz4cli -j"$J" >/dev/null 2>&1 \
    && cp "$BUILD/lz4-build/lz4" "$OUT/lz4"
}

build_xz() {
  echo "== xz 5.8.3"
  rm -rf "$BUILD/xz-src"
  tar xf "$BUILD/xz-5.8.3.tar.gz" -C "$BUILD" && mv "$BUILD/xz-5.8.3" "$BUILD/xz-src"
  (cd "$BUILD/xz-src" \
    && ./configure --disable-shared --enable-static --disable-doc \
         CFLAGS="-O2" LDFLAGS="-static" >/dev/null 2>&1 \
    && make -j"$J" LDFLAGS="-all-static" >/dev/null 2>&1 \
    && cp src/xz/xz "$OUT/xz")
}

build_brotli() {
  echo "== brotli 1.2.1"
  rm -rf "$BUILD/brotli-src" "$BUILD/brotli-build"
  tar xf "$BUILD/v1.2.1.tar.gz" -C "$BUILD" && mv "$BUILD/brotli-1.2.1" "$BUILD/brotli-src"
  cmake -S "$BUILD/brotli-src" -B "$BUILD/brotli-build" \
    -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS=-static >/dev/null 2>&1 \
    && cmake --build "$BUILD/brotli-build" --target brotli -j"$J" >/dev/null 2>&1 \
    && cp "$BUILD/brotli-build/brotli" "$OUT/brotli"
}

build_file() {
  echo "== file 5.46"
  rm -rf "$BUILD/file-src"
  tar xf "$BUILD/file-5.46.tar.gz" -C "$BUILD" && mv "$BUILD/file-5.46" "$BUILD/file-src"
  (cd "$BUILD/file-src" \
    && ./configure --disable-shared --enable-static LDFLAGS="-static" >/dev/null 2>&1 \
    && make -j"$J" LDFLAGS="-all-static" >/dev/null 2>&1 \
    && cp src/file "$OUT/file")
}

build_zstd
build_lz4
build_xz
build_brotli
build_file

echo "--- built ---"
for f in "$OUT"/*; do
  printf '%-12s ' "$(basename "$f")"
  file -b "$f" | cut -c1-58
  "$f" --version 2>/dev/null | head -1
done
