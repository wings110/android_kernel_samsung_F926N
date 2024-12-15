#!/bin/bash

export ARCH=arm64
export PROJECT_NAME=q2q
mkdir out

BUILD_CROSS_COMPILE=$HOME/Toolchains_for_Snapdragon/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$HOME/Toolchains_for_Snapdragon/llvm-arm-toolchain-ship-10.0/bin/clang
CLANG_TRIPLE=$HOME/Toolchains_for_Snapdragon/llvm-arm-toolchain-ship-10.0/bin/aarch64-linux-gnu-
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"

#symlinking python2
if [ ! -f "$HOME/python" ]; then
    ln -s /usr/bin/python2.7 "$HOME/python"
fi 

export PATH=$HOME:$PATH

make -j64 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y vendor/q2q_kor_singlex_defconfig
make -j64 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y
 
cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image

#to copy all the kernel modules (.ko) to "modules" folder.
cd out
mkdir -p modules
find . -type f -name "*.ko" -exec cp -n {} modules \;
echo "Module files copied to the 'modules' folder."
