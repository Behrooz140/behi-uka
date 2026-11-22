# behi UKA 6.0 — changelog

[Persian version](CHANGELOG.fa.md)

Based on `UKA_5.39_Magisk_EN_@Aadez007.zip` (the last release by the original author
kory-vadim, English translation by @Aadez007).

## Overview

- `id=behi_uka` — avoids an id collision with the original `UKA` module.
- `version=6.0`, `versionCode=600`, `author=behi`.
- behi branding was added only in `module.prop`, the installer banner and the
  menu "about" line.
- Paths and command names are unchanged: `/data/local/binary`,
  `/data/local/python31`, `/data/local/AIK-mobile`, `$MODPATH/system/bin/menu`.
- `uninstall.sh` and the in-menu uninstall option remove the `behi_uka` module path.

## Upgraded binaries

| Tool | Old | New | Source |
|---|---|---|---|
| `avbroot` | 3.9.0 | **3.39.1** | official android31 aarch64 release |
| `avbtool` / `avbtool.py` | AOSP 1.3.0 (2023) | **AOSP main 1.3.0** | Android googlesource |
| `payload-dumper` | devel | **2.1.0** | ssut/payload-dumper-go |
| `busybox` (binary64 + AIK) | 1.32.1-osm0sis | **1.36.1-osm0sis (SELinux)** | busybox-ndk release 13614 |
| `e2fsck`, `mke2fs`, `resize2fs`, `tune2fs` | 1.45.4 (2019) | **1.47.4** | tytso/e2fsprogs (static ARM64) |
| `openssl` | 3.0.12 | **3.5.5** | OpenSSL release (static ARM64) |
| `zstd64` | 1.5.2 | **1.5.7** | facebook/zstd (static) |
| `lz4` | 1.9.3 | **1.11.1** | lz4/lz4 (static) |
| `brotli` | 1.1.0 | **1.2.1** | google/brotli (static) |
| `xz` | 5.2.4 | **5.8.3** | tukaani-project/xz (static) |
| `file` | 5.40 | **5.46** | file (static) |

Every newly built binary is **static ARM64** and was executed successfully on an
aarch64 host.

## Binaries intentionally left unchanged

- `mkfs.erofs` and `extract.erofs64` — custom UKA/Rosenberg forks using
  `--only-cfg`, `--product-out`, `-E^xattr-name-filter` and emitting `fs_options`.
  Replacing them with upstream erofs-utils breaks the unpack → repack chain.
- `erofsfuse`, `dump.erofs`, `fsck.erofs` — an upstream upgrade would need NDK/FUSE
  and brings no practical benefit to the menu.
- `make_ext4fs`, `e2fsdroid`, `lpunpack`, `lpdump`, `lpmake`, `lpadd`, `lpflash` —
  AOSP binaries; the menu relies on their legacy CLI and the text format of `lpdump`.
- `otadump7x64`, `bootpatch`, `bin_utils`, `afptool`, `img_maker`, `img_unpack`,
  other third-party tools and AIK-mobile 3.8.
- The `/data/local/python31` tree (Python 3.11) — about 84 compiled `.so` modules
  use the `cpython-311` ABI; moving to 3.12+ would break all of them.

## Build

```sh
cd behi-uka
./build.sh
# output: out/behi_uka_6.0_Magisk_arm64.zip
```
