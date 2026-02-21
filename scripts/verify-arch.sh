#!/usr/bin/env bash
# Verify that the produced toolchain binaries target the correct host architecture.
# Env vars required:
#   PREFIX     - installation prefix, e.g. /opt/riscv-armhf-rv32e
#   FILE_GREP  - regex passed to file(1) to check the binary type, e.g. "ARM" | "aarch64|ARM aarch64"
set -euo pipefail

: "${PREFIX:?}" "${FILE_GREP:?}"

BIN="${PREFIX}/bin/riscv32-corev-elf-gcc"
if [[ ! -x "${BIN}" ]]; then BIN="${PREFIX}/bin/riscv64-corev-elf-gcc"; fi
if [[ ! -x "${BIN}" ]]; then BIN="${PREFIX}/bin/riscv32-unknown-elf-gcc"; fi
if [[ ! -x "${BIN}" ]]; then BIN="${PREFIX}/bin/riscv64-unknown-elf-gcc"; fi

test -x "${BIN}"
file "${BIN}" | grep -Eqi "${FILE_GREP}"
