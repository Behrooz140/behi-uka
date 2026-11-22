# Upstream sources used for the 6.0 tool upgrades

Build scripts in this folder rebuild the static ARM64 binaries that are committed
under `payload/`. They are provided for reproducibility; `build.sh` does not need
them because the binaries are already in the repository.

| Binary | Version | Source |
|---|---|---|
| `e2fsck`, `mke2fs`, `resize2fs`, `tune2fs` | 1.47.4 | https://github.com/tytso/e2fsprogs/archive/refs/tags/v1.47.4.tar.gz |
| `openssl` | 3.5.5 | https://github.com/openssl/openssl/releases/tag/openssl-3.5.5 |
| `zstd64` | 1.5.7 | https://github.com/facebook/zstd/releases/tag/v1.5.7 |
| `lz4` | 1.11.1 | https://github.com/lz4/lz4/releases/tag/v1.11.1 |
| `brotli` | 1.2.1 | https://github.com/google/brotli/archive/refs/tags/v1.2.1.tar.gz |
| `xz` | 5.8.3 | https://github.com/tukaani-project/xz/releases/tag/v5.8.3 |
| `file` | 5.46 | https://astron.com/pub/file/file-5.46.tar.gz |
| `busybox` | 1.36.1-osm0sis | https://github.com/Magisk-Modules-Repo/busybox-ndk/releases/tag/13614 |
| `avbroot` | 3.39.1 | https://github.com/chenxiaolong/avbroot/releases/tag/v3.39.1 |
| `payload-dumper` | 2.1.0 | https://github.com/ssut/payload-dumper-go/releases/tag/2.1.0 |
| `avbtool.py` | AOSP main | https://android.googlesource.com/platform/external/avb/+/refs/heads/main/avbtool.py |

Notes:

- `build_simple.sh` builds zstd, lz4, xz, brotli and file.
- `build_e2fsprogs.sh` builds the e2fsprogs utilities.
- `build_openssl.sh` builds a fully static OpenSSL CLI.
- `build_erofs.sh` is an experiment; its output is **not** used because UKA relies
  on a custom erofs fork (see CHANGELOG.md).

All binaries were cross-built on an aarch64 Linux host with the system compiler.
Static linking is required so they run on Bionic/Android without glibc libraries.
