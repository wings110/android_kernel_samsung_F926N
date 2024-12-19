#!/bin/bash
export ARCH=arm64
ln -s /usr/bin/python2.7 $HOME/python
export PATH=$HOME/:$HOME/proton-12/bin:$PATH # Proton 的路径
mkdir out
clear

ARGS="
CC=clang
CROSS_COMPILE=aarch64-linux-gnu-
ARCH=arm64
LD=ld.lld
AR=llvm-ar
NM=llvm-nm
OBJCOPY=llvm-objcopy
OBJDUMP=llvm-objdump
READELF=llvm-readelf
OBJSIZE=llvm-size
STRIP=llvm-strip
LLVM_AR=llvm-ar
LLVM_DIS=llvm-dis
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
"
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS} clean && make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} mrproper
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS} vendor/q2q_kor_singlex_defconfig
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS} menuconfig
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS}

# 将所有内核模块（.ko）复制到 "modules" 文件夹
cd out
mkdir -p modules
find . -type f -name "*.ko" -exec cp -n {} modules \;
echo "Module files copied to the 'modules' folder."

