#!/usr/bin/env bash
# Enable binfmt_misc for QEMU transparent emulation and run a smoke test.
# Env vars required:
#   QEMU_BINFMT   - e.g. qemu-arm | qemu-aarch64
#   FOREIGN_ARCH  - e.g. armhf | arm64
#   HOST_TRIPLET  - e.g. arm-linux-gnueabihf | aarch64-linux-gnu
set -euo pipefail

: "${QEMU_BINFMT:?}" "${FOREIGN_ARCH:?}" "${HOST_TRIPLET:?}"

sudo modprobe binfmt_misc || true
if ! mount | grep -q "binfmt_misc on /proc/sys/fs/binfmt_misc"; then
  sudo mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc || true
fi

sudo systemctl restart systemd-binfmt || true
sudo update-binfmts --enable "${QEMU_BINFMT}" || true

sudo update-binfmts --display "${QEMU_BINFMT}" || true
ls -la /proc/sys/fs/binfmt_misc || true

cat > /tmp/hello.c <<'CSRC'
int main(){ return 0; }
CSRC

out="/tmp/hello_${FOREIGN_ARCH}"
"${HOST_TRIPLET}-gcc" -static /tmp/hello.c -o "${out}"
file "${out}"
"${out}"
