#!/bin/bash
# UKA 6.0 builder — rebuilds the flashable Magisk module zip from payload/ + src/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/src"
PAYLOAD="$ROOT/payload"
OUT="$ROOT/out"
VERSION_FILE="$SRC/module.prop"
VERSION="$(sed -n 's/^version=\([^ ]*\).*/\1/p' "$VERSION_FILE")"
MODID="$(sed -n 's/^id=//p' "$VERSION_FILE")"
ZIP="${MODID}_${VERSION}_Magisk_arm64.zip"

command -v tar >/dev/null
command -v zip >/dev/null

rm -f "$OUT/$ZIP"

for name in aik64 bin64 binary64 python31_64; do
  echo ">> packing $name.tar.xz"
  (cd "$PAYLOAD/$name" && tar --sort=name --owner=0 --group=0 --numeric-owner \
      -cJf "$SRC/$name.tar.xz" .)
done

echo ">> creating $ZIP"
(cd "$SRC" && zip -q -r -9 -X "$OUT/$ZIP" \
  META-INF \
  README.md module.prop install.sh uninstall.sh \
  aik64.tar.xz bin64.tar.xz binary64.tar.xz python31_64.tar.xz)

ls -lh "$OUT/$ZIP"
sha256sum "$OUT/$ZIP"
