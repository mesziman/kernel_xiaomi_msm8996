#!/bin/bash

KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
CCACHEDIR=../CCACHE/capricorn
TOOLCHAINDIR=/pipeline/build/root/toolchain/aarch64-linux-android-4.9
TOOLCHAIN32=/pipeline/build/root/toolchain/arm-linux-androideabi-4.9
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Syberia"
DEVICE="-capricorn-"
VER="-0.1"
TYPE="PIE-EAS"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/capricorn/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb
#PATH="/pipeline/build/root/toolchain/gclang/clang-r349610/bi
PATH="${PATH}:${TOOLCHAINDIR}/bin:${TOOLCHAIN32}/bin"
export ARCH=arm64
export KBUILD_BUILD_USER="mesziman"
export KBUILD_BUILD_HOST="github"
#export CC=/pipeline/build/root/toolchain/dtc/bin/clang
#export CC=/pipeline/build/root/toolchain/gclang/clang-r349610/bin
#export CXX=/pipeline/build/root/toolchain/dtc/bin/clang++
export CC=clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE32=arm-linux-androideabi-
export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

make clean && make mrproper
make capricorn_defconfig
make -j$( nproc --all )

{
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/capricorn
} || {
if [ $? != 0 ]; then
  echo "FAILED BUILD"
fi
}

cd $ANYKERNEL_DIR/capricorn
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
mv $FINAL_ZIP /pipeline/output/$FINAL_ZIP
