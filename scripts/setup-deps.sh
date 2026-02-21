#!/usr/bin/env bash
# Install base build dependencies.
# Env vars required:
#   GCC_PKG       - e.g. gcc-arm-linux-gnueabihf
#   GXX_PKG       - e.g. g++-arm-linux-gnueabihf
#   BINUTILS_PKG  - e.g. binutils-arm-linux-gnueabihf
set -euo pipefail

: "${GCC_PKG:?}" "${GXX_PKG:?}" "${BINUTILS_PKG:?}"

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
  autoconf automake autotools-dev curl gawk build-essential \
  bison flex texinfo gperf libtool patchutils bc \
  zlib1g-dev libexpat-dev git ca-certificates \
  gettext \
  qemu-user-static binfmt-support \
  "${GCC_PKG}" "${GXX_PKG}" "${BINUTILS_PKG}" \
  libgmp-dev libmpfr-dev libmpc-dev
