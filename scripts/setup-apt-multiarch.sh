#!/usr/bin/env bash
# Configure APT sources for multiarch and add the foreign-arch ports repository.
# Env vars required:
#   FOREIGN_ARCH  - e.g. armhf | arm64
set -euo pipefail

: "${FOREIGN_ARCH:?}"

if [[ -f /etc/apt/sources.list.d/ubuntu.sources ]]; then
  SIGNED_BY="$(awk -F': ' 'tolower($1)=="signed-by"{print $2; exit}' \
    /etc/apt/sources.list.d/ubuntu.sources || true)"
  if [[ -z "${SIGNED_BY}" ]]; then
    SIGNED_BY="/usr/share/keyrings/ubuntu-archive-keyring.gpg"
  fi
  sudo tee /etc/apt/sources.list.d/ubuntu.sources >/dev/null <<EOF
Types: deb
URIs: http://archive.ubuntu.com/ubuntu
Suites: jammy jammy-updates jammy-backports
Components: main restricted universe multiverse
Architectures: amd64
Signed-By: ${SIGNED_BY}

Types: deb
URIs: http://security.ubuntu.com/ubuntu
Suites: jammy-security
Components: main restricted universe multiverse
Architectures: amd64
Signed-By: ${SIGNED_BY}
EOF
else
  if [[ -f /etc/apt/sources.list ]]; then
    sudo sed -i -E 's/^deb(\s+)/deb [arch=amd64]\1/' /etc/apt/sources.list
  fi
fi

sudo dpkg --add-architecture "${FOREIGN_ARCH}"

sudo tee "/etc/apt/sources.list.d/ubuntu-ports-${FOREIGN_ARCH}.list" >/dev/null <<EOF
deb [arch=${FOREIGN_ARCH}] http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse
deb [arch=${FOREIGN_ARCH}] http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted universe multiverse
deb [arch=${FOREIGN_ARCH}] http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted universe multiverse
EOF

sudo apt-get update -y --allow-releaseinfo-change
