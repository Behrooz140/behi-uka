#!/bin/bash
# Build static ARM64 OpenSSL 3.5.5 CLI.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
BUILD="/root/uka_build"
OUT="$HERE/bin"
J="$(nproc)"
mkdir -p "$BUILD" "$OUT"
cp -n "$HERE/src/openssl-3.5.5.tar.gz" "$BUILD/" 2>/dev/null || true
cd "$BUILD"
rm -rf openssl-src
tar xf openssl-3.5.5.tar.gz && mv openssl-3.5.5 openssl-src
cd openssl-src
./Configure linux-aarch64 no-shared no-tests no-docs > "$BUILD/openssl-conf.log" 2>&1 || {
  tail -20 "$BUILD/openssl-conf.log"; exit 1; }
make -j"$J" > "$BUILD/openssl-make.log" 2>&1 || { tail -40 "$BUILD/openssl-make.log"; exit 1; }
cp apps/openssl "$OUT/openssl"
echo "  -> openssl"
