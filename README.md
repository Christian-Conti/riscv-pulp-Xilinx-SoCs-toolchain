# RISC-V GCC Toolchain for X-HEEP (OpenHW Core-V) on ARM Hosts

This repository automates the build process of the [RISC-V GNU Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) (patched with OpenHW Group Core-V GCC and Binutils for `xcv*` custom extensions) specifically for **ARM32 (armhf)** (e.g., Xilinx PYNQ-Z2 board) and **ARM64 (aarch64)** hosts, targeting the X-HEEP platform.

## Features
* **Automated Builds:** Trigger the build manually or let the scheduled Cron job keep the compiler up to date automatically.
* **Multi-Host Support:** Generates native host toolchains for both 32-bit (`armhf`) and 64-bit (`aarch64`) ARM architectures.
* **Ready-to-use Artifacts:** Outputs compressed `.tar.gz` packages published directly to a rolling GitHub Release, ready to be deployed on the target board.
* **X-HEEP & Core-V Ready:** Configured with specific multilibs and OpenHW patches to support custom `xcv` instructions.

## How to Use

### 1a. Manually Generate the Toolchain
1. Go to the **Actions** tab in this repository.
2. Select the **Build RISC-V Toolchain (host armhf + aarch64, target X-HEEP rv32)** workflow.
3. Click **Run workflow** to start the compilation.

### 1b. Automatically Generate the Toolchain
The workflow starts automatically on the **1st of every month at 2:00 AM UTC** to ensure the toolchain is kept up to date.

### 2. Download and Install on the Target Board
1. Go to the **Releases** section of this repository and look for the `latest` release.
2. Download the appropriate `.tar.gz` archive for your board's architecture:
   * `riscv-toolchain-host-armhf-xheep-rv32imac.tar.gz` (for 32-bit ARM, e.g., PYNQ-Z2)
   * `riscv-toolchain-host-aarch64-xheep-rv32imac.tar.gz` (for 64-bit ARM)
3. Transfer the file to your board.
4. Extract the archive to the root directory (the archive already contains the `/opt/riscv-armhf` or `/opt/riscv-aarch64` structure):
   ```bash
   sudo tar -xzvf riscv-toolchain-host-armhf-xheep-rv32imac.tar.gz -C /
