# UKA 6.0 — behi build

[![version](https://img.shields.io/badge/version-6.0-blue.svg)](https://github.com/Behrooz140/behi-uka/releases)
[![platform](https://img.shields.io/badge/platform-Android%20arm64-green.svg)](https://github.com/Behrooz140/behi-uka)
[![Magisk](https://img.shields.io/badge/Magisk-module-orange.svg)](https://github.com/topjohnwu/Magisk)

**Persian documentation:** [README.fa.md](README.fa.md)

`behi_uka` is a maintained rebuild of the **Unpacker Kitchen for Android (UKA)** 5.39
module originally created by **kory-vadim** and translated into English by **@Aadez007**.
The original project is no longer maintained, so this fork updates the bundled toolchain
while keeping every path, command name and menu behaviour exactly the same.

## What it does

- Unpack and rebuild `boot.img` / `recovery.img` (via the bundled AIK-mobile)
- Unpack, edit and repack `system.img`, `vendor.img`, `super.img` and other partitions
- Convert between `raw`, `sparse`, `.dat` and `.br` (brotli) formats
- Handle `payload.bin` OTA packages and Qualcomm QFIL split images
- Work with ext4, EROFS and F2FS filesystems
- Extract `file_contexts` and convert `file_contexts.bin` on the device
- Assemble super images with AOSP `lpmake`

Everything runs **on the phone**, from a terminal emulator.

## Installation

1. Install [Magisk](https://github.com/topjohnwu/Magisk).
2. Flash `behi_uka_6.0_Magisk_arm64.zip` from Magisk → Modules → Install from storage.
3. Reboot.

> The module id is `behi_uka`, so it can be installed alongside the original `UKA`
> module without an id collision. Both modules use the same `/data/local/...` working
> directories, so do not run them at the same time.

## Usage

Open a terminal emulator on the device:

```sh
su
menu
```

The main menu looks and behaves like UKA 5.39. The only visible changes are the
`6.0` / `behi build` branding and the module id used by the uninstaller.

## What changed in 6.0

| Tool | Old | New |
|---|---|---|
| `avbroot` | 3.9.0 | **3.39.1** |
| `avbtool.py` | old AOSP snapshot | **current AOSP main** |
| `payload-dumper` | development build | **2.1.0** |
| `busybox` | 1.32.1-osm0sis | **1.36.1-osm0sis (SELinux)** |
| `e2fsck`, `mke2fs`, `resize2fs`, `tune2fs` | 1.45.4 | **1.47.4** |
| `openssl` | 3.0.12 | **3.5.5** |
| `zstd64` | 1.5.2 | **1.5.7** |
| `lz4` | 1.9.3 | **1.11.1** |
| `brotli` | 1.1.0 | **1.2.1** |
| `xz` | 5.2.4 | **5.8.3** |
| `file` | 5.40 | **5.46** |

All newly built binaries are **static ARM64** executables. See
[CHANGELOG.md](CHANGELOG.md) for the full list and for the tools that were
intentionally left unchanged.

## Repository layout

```
.
├── README.md          # this file (English, default)
├── README.fa.md       # Persian documentation
├── CHANGELOG.md       # English changelog
├── CHANGELOG.fa.md    # Persian changelog
├── CREDITS.md
├── build.sh           # rebuilds the flashable ZIP
├── src/               # ZIP root: install.sh, uninstall.sh, module.prop, META-INF
├── payload/           # unpacked contents of the four tar.xz archives
│   ├── aik64/         #   -> AIK-mobile/
│   ├── bin64/         #   -> bin/   (installed to $MODPATH/system/bin)
│   ├── binary64/      #   -> local/ (installed to /data/local/binary)
│   └── python31_64/   #   -> python31/ (installed to /data/local/python31)
└── tools/             # helper scripts used to rebuild the upstream binaries
    └── SOURCES.md     # download locations for upstream sources / releases
```

## Build from source

On any Linux machine (the build only needs `tar`, `zip`, `xz`, `cmake`, `gcc`):

```sh
./build.sh
```

The flashable module is written to `out/behi_uka_6.0_Magisk_arm64.zip`.

The helper scripts under `tools/` document how each upstream binary was rebuilt.
They are not required for a normal rebuild because the resulting binaries are already
committed under `payload/`.

## Compatibility notes

`mkfs.erofs` and `extract.erofs64` are custom UKA/Rosenberg forks that understand
`--only-cfg`, `--product-out`, `-E^xattr-name-filter` and emit `fs_options`.
Replacing them with upstream `erofs-utils` would break the unpack → repack chain, so
they are kept at their original versions. The same applies to `make_ext4fs`,
`e2fsdroid`, the AOSP logical-partition tools, AIK-mobile 3.8 and the bundled
Python 3.11 runtime (it has ~84 compiled `cpython-311` extension modules).

## Credits

See [CREDITS.md](CREDITS.md). Original UKA by kory-vadim; English translation by
@Aadez007; AIK-mobile by osm0sis; this rebuild and branding by **behi**.

## Disclaimer

This module modifies system images. Always keep backups of your firmware and test
the menu actions on a device you can restore. Provided as-is, without warranty.
