#!/usr/bin/env bash
# Clone riscv-gnu-toolchain and patch GCC + Binutils to Core-V development branches.
# Env vars required:
#   GH_TOKEN  - GitHub token for authentication (set by the workflow)
set -euo pipefail

rm -rf riscv-gnu-toolchain
export GIT_TERMINAL_PROMPT=0

git config --global --unset-all http.https://github.com/.extraheader || true
git config --global --unset-all url."https://x-access-token:${GH_TOKEN:-}@github.com/".insteadOf || true
git config --global --unset-all url."https://x-access-token:@github.com/".insteadOf || true

git config --global http.version HTTP/1.1
git config --global fetch.parallel 4

git clone --depth 1 https://github.com/riscv-collab/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain

git config -f .gitmodules submodule.binutils.url https://sourceware.org/git/binutils-gdb.git
git config -f .gitmodules submodule.newlib.url   https://sourceware.org/git/newlib-cygwin.git
git submodule sync --recursive

for attempt in 1 2 3 4 5; do
  if git submodule update --init --depth 1 --jobs 8 gcc binutils newlib; then
    break
  fi
  sleep $((attempt * 10))
  if [[ "${attempt}" -eq 5 ]]; then
    echo "Submodule update (gcc/binutils/newlib) failed after ${attempt} attempts"
    exit 1
  fi
done

for attempt in 1 2 3 4 5; do
  if git submodule update --init --jobs 2 gdb; then
    break
  fi
  sleep $((attempt * 15))
  if [[ "${attempt}" -eq 5 ]]; then
    echo "Submodule update (gdb) failed after ${attempt} attempts"
    exit 1
  fi
done

cd gcc
git remote add corev https://github.com/openhwgroup/corev-gcc.git || true
git fetch --depth 1 corev development
git checkout -B corev-development FETCH_HEAD
cd ..

cd binutils
git remote add corev https://github.com/openhwgroup/corev-binutils-gdb.git || true
git fetch --depth 1 corev development
git checkout -B corev-development FETCH_HEAD
cd ..
