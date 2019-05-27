#!/bin/bash


dpkg --add-architecture i386 && apt-get -qq update && apt-get -qq install -y git ccache automake bc lzop bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 g++-multilib python-networkx libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng  libssl-dev &&
export LOFASZ=$PWD &&
git clone --depth=10 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 /pipeline/build/root/toolchain/aarch64-linux-android-4.9 &&
cd /pipeline/build/root/toolchain/aarch64-linux-android-4.9 && git reset --hard 22f053ccdfd0d73aafcceff3419a5fe3c01e878b &&
git clone --depth=10 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 /pipeline/build/root/toolchain/arm-linux-androideabi-4.9 &&
cd /pipeline/build/root/toolchain/arm-linux-androideabi-4.9 && git reset --hard 42e5864a7d23921858ca8541d52028ff88acb2b6 &&
cd $LOFASZ
bash builder-mi5s.sh
