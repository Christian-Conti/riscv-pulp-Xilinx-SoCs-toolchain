#!/usr/bin/env bash
# Verify that the toolchain can compile a minimal C file to a RISC-V ELF.
# Env vars required:
#   PREFIX  - installation prefix, e.g. /opt/riscv-armhf-rv32e
#   ARCH    - RISC-V arch string, e.g. rv32emac
#   ABI     - RISC-V ABI string, e.g. ilp32e
set -euo pipefail

: "${PREFIX:?}" "${ARCH:?}" "${ABI:?}"

export PATH="${PREFIX}/bin:${PATH}"

cat > rvtest.c <<'CSRC'
int add(int a, int b){ return a + b; }
CSRC

COMPILER="$(find "${PREFIX}/bin" -maxdepth 1 -type f -name "*-gcc" | head -n 1)"
test -n "${COMPILER}"

"${COMPILER}" -march="${ARCH}" -mabi="${ABI}" -c -o rvtest.o rvtest.c
file rvtest.o | grep -qiE "ELF (32|64)-bit"
readelf -h rvtest.o | grep -qi "Machine:.*RISC-V"
