#!/usr/bin/env bash
# Configure and build the RISC-V toolchain (newlib + gdb).
# Env vars required:
#   PREFIX        - installation prefix, e.g. /opt/riscv-armhf-rv32e
#   HOST_TRIPLET  - e.g. arm-linux-gnueabihf
#   ARCH          - RISC-V arch string, e.g. rv32emac
#   ABI           - RISC-V ABI string, e.g. ilp32e
#   MULTILIBS     - multilib generator string
#   PKGVERSION    - package version string (set by workflow metadata step)
set -euo pipefail

: "${PREFIX:?}" "${HOST_TRIPLET:?}" "${ARCH:?}" "${ABI:?}" "${MULTILIBS:?}" "${PKGVERSION:?}"

export CC="ccache ${HOST_TRIPLET}-gcc"
export CXX="ccache ${HOST_TRIPLET}-g++"
export AR="${HOST_TRIPLET}-ar"
export RANLIB="${HOST_TRIPLET}-ranlib"
export CC_FOR_BUILD="ccache gcc"
export CXX_FOR_BUILD="ccache g++"

cd riscv-gnu-toolchain

./configure \
  --prefix="${PREFIX}" \
  --host="${HOST_TRIPLET}" \
  --build="x86_64-linux-gnu" \
  --with-sysroot="${PREFIX}/riscv-corev-elf" \
  --with-native-system-header-dir=/include \
  --with-newlib \
  --disable-shared \
  --enable-languages=c,c++ \
  --enable-tls \
  --disable-werror \
  --disable-libmudflap \
  --disable-libssp \
  --disable-quadmath \
  --disable-libgomp \
  --disable-nls \
  --disable-libbacktrace \
  --enable-multilib \
  --with-multilib-generator="${MULTILIBS}" \
  --with-arch="${ARCH}" \
  --with-abi="${ABI}" \
  --with-bugurl="https://github.com/Christian-Conti/riscv-Xilinx-SoCs-toolchain" \
  --with-pkgversion="${PKGVERSION}"

TARGET_CFLAGS="-Os -g0"

make -j"$(nproc)" newlib \
  HOST="${HOST_TRIPLET}" \
  BUILD="x86_64-linux-gnu" \
  CFLAGS_FOR_TARGET="${TARGET_CFLAGS}" \
  CXXFLAGS_FOR_TARGET="${TARGET_CFLAGS}"

if make -n gdb >/dev/null 2>&1; then
  make -j"$(nproc)" gdb \
    HOST="${HOST_TRIPLET}" \
    BUILD="x86_64-linux-gnu" \
    CFLAGS_FOR_TARGET="${TARGET_CFLAGS}" \
    CXXFLAGS_FOR_TARGET="${TARGET_CFLAGS}"
fi
