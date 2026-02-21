#!/usr/bin/env bash
# Install GCC build-time libraries for the foreign (host) architecture.
# Env vars required:
#   FOREIGN_ARCH  - e.g. armhf | arm64
set -euo pipefail

: "${FOREIGN_ARCH:?}"

sudo apt-get install -y --no-install-recommends \
  "libgmp-dev:${FOREIGN_ARCH}" \
  "libmpfr-dev:${FOREIGN_ARCH}" \
  "libmpc-dev:${FOREIGN_ARCH}" \
  "zlib1g-dev:${FOREIGN_ARCH}" \
  "libexpat1-dev:${FOREIGN_ARCH}"
