# behi UKA 6.0 — changelog

مبتنی بر `UKA_5.39_Magisk_EN_@Aadez007.zip` (آخرین نسخه منتشرشده توسط نویسنده اصلی kory-vadim، ترجمه انگلیسی @Aadez007).

## مشخصات کلی

- `id=behi_uka` — برای جلوگیری از تداخل با ماژول اصلی `UKA`.
- `version=6.0`، `versionCode=600`، `author=behi`.
- برندینگ behi فقط در `module.prop`، بنر نصاب `install.sh` و صفحه «درباره» منو اضافه شد.
- مسیرها و نام دستورها دقیقاً مشابه 5.39 باقی ماندند:
  `/data/local/binary`, `/data/local/python31`, `/data/local/AIK-mobile`, `$MODPATH/system/bin/menu`.
- `uninstall.sh` و گزینهٔ «Uninstall» داخل منو، مسیر ماژول `behi_uka` را پاک میکنند.

## باینریهای ارتقایافته

| ابزار | قدیم | جدید | منبع |
|---|---|---|---|
| `avbroot` | 3.9.0 | **3.39.1** | release رسمی android31 aarch64 |
| `avbtool` / `avbtool.py` | AOSP 1.3.0 (2023) | **AOSP main 1.3.0** (آخرین تغییرات additive) | Android googlesource |
| `payload-dumper` | devel | **2.1.0** | ssut/payload-dumper-go release |
| `busybox` (binary64 + AIK) | 1.32.1-osm0sis | **1.36.1-osm0sis (selinux)** | busybox-ndk release 13614 |
| `e2fsck`, `mke2fs`, `resize2fs`, `tune2fs` | 1.45.4 (2019) | **1.47.4** (static ARM64) | tytso/e2fsprogs |
| `openssl` | 3.0.12 | **3.5.5** (static ARM64) | OpenSSL release |
| `zstd64` | 1.5.2 | **1.5.7** (static) | facebook/zstd |
| `lz4` | 1.9.3 | **1.11.1** (static) | lz4/lz4 |
| `brotli` | 1.1.0 | **1.2.1** (static) | google/brotli |
| `xz` | 5.2.4 | **5.8.3** (static) | tukaani-project/xz |
| `file` | 5.40 | **5.46** (static) | file |

تمام باینریهای تازه ساختهشده **static ARM64**اند و رویhost aarch64 اجرا و تست شدند.

## باینریهایی که عمداً تغییر نکردند

- `mkfs.erofs` و `extract.erofs64` — فورک اختصاصی UKA/Rosenberg با فلگهای
  `--only-cfg`, `--product-out`, `-E^xattr-name-filter` و خروجی `fs_options`.
  جایگزینی با erofs-utils upstream زنجیره unpack→repackرا میشکند.
- `erofsfuse`, `dump.erofs`, `fsck.erofs` — ارتقای upstream نیازمند NDK/FUSE داشت و
  سود عملی بر nomenu نداشت.
- `make_ext4fs`, `e2fsdroid`, `lpunpack`, `lpdump`, `lpmake`, `lpadd`, `lpflash` —
  باینریهای AOSP؛ منو بهConcrete CLI قدیمی و فرمت متن `lpdump` وابسته است.
- `otadump7x64`, `bootpatch`, `bin_utils`, `afptool`, `img_maker`, `img_unpack`،
  ابزارهای سفاری/Third-party و AIK-mobile 3.8.
- درخت `/data/local/python31` (Python 3.11) — حدود ۸۴ ماژول `.so` با ABI `cpython-311`
  دارد؛ ارتقا به 3.12+ تمام پکیجها و شیbangها را میشکند.

## ساخت

```sh
cd UKA_6.0
./build.sh
# خروجی: out/behi_uka_6.0_Magisk_arm64.zip
```
