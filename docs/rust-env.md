# RUST env

## Clone linux tree

### Linux commands

make LLVM=1 rustavailable

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

vim Documentation/rust/quick-start.rst

cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen

rustup component add rust-src

make LLVM=1 allnoconfig qemu-busybox-min.config rust.config

make LLVM=1 rust-analyzer

make LLVM=1 rustfmt

make LLVM=1 rustfmtcheck

make LLVM=1 rustdoc

make LLVM=1 rusttest

make LLVM=1 -j$(nproc) CLIPPY=1

## Busybox

git clone https://git.busybox.net/busybox

make -j$(nproc)

make install

cd _install

find . | cpio -H newc -o | gzip > ../ramdisk.img

### Busybox commands

## QEMU

git clone https://gitlab.com/qemu-project/qemu.git --recurse-submodules

cd qemu && mkdir -p build

cd build

../configure --prefix=/usr/ --enable-debug
