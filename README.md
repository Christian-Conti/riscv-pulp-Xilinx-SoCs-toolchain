# RISC-V GCC Toolchain for X-HEEP (OpenHW Core-V) on ARM Hosts

This repository automates the build process of the [RISC-V GNU Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) (patched with OpenHW Group Core-V GCC and Binutils for `xcv*` custom extensions) specifically for **ARM32 (armhf)** and **ARM64 (aarch64)** hosts, targeting RISC-V (including X-HEEP/Core-V custom extensions).

## Features

- **Automated Builds:** Trigger the build manually or let the scheduled Cron job keep the compiler up to date automatically.
- **Multi-Host Support:** Generates native host toolchains for both 32-bit (`armhf`) and 64-bit (`aarch64`) ARM architectures.
- **Split Flavors (Time Limit Friendly):** The build is split into multiple “flavors” (multilib subsets) to stay within GitHub Actions time limits.
- **Ready-to-use Artifacts:** Outputs compressed `.tar.gz` packages published directly to a rolling GitHub Release.
- **X-HEEP & Core-V Ready:** Uses OpenHW Core-V GCC/Binutils branches and includes multilibs for `xcv*` custom extensions.

## Flavors (Multilib Splits)

Each host architecture produces multiple toolchains, one per flavor. All flavors use the same global configure style (newlib, multilib enabled, Core-V GCC/Binutils), but differ in `--with-multilib-generator`, `--with-arch`, and `--with-abi`.

### RV32 Standard

#### `rv32e`
- Default: `--with-arch=rv32emac`, `--with-abi=ilp32e`
- Multilib set:
  - `rv32e-ilp32e--c`
  - `rv32ea-ilp32e--m`
  - `rv32em-ilp32e--c`
  - `rv32eac-ilp32e--`
  - `rv32emac-ilp32e--`

#### `rv32i-imac`
- Default: `--with-arch=rv32imac`, `--with-abi=ilp32`
- Multilib set:
  - `rv32i-ilp32--c`
  - `rv32ia-ilp32--m`
  - `rv32im-ilp32--c`
  - `rv32iac-ilp32--`
  - `rv32imac-ilp32--`

#### `rv32-float`
- Default: `--with-arch=rv32imafdc`, `--with-abi=ilp32d`
- Multilib set:
  - `rv32if-ilp32f-rv32ifd-c`
  - `rv32iaf-ilp32f-rv32imaf,rv32iafc-d`
  - `rv32imf-ilp32f-rv32imfd-c`
  - `rv32imafc-ilp32f-rv32imafdc-`
  - `rv32ifd-ilp32d--c`
  - `rv32imfd-ilp32d--c`
  - `rv32iafd-ilp32d-rv32imafd,rv32iafdc-`
  - `rv32imafdc-ilp32d--`

### RV64 Standard

#### `rv64i-imac`
- Default: `--with-arch=rv64imac`, `--with-abi=lp64`
- Multilib set:
  - `rv64i-lp64--c`
  - `rv64ia-lp64--m`
  - `rv64im-lp64--c`
  - `rv64iac-lp64--`
  - `rv64imac-lp64--`

#### `rv64-float`
- Default: `--with-arch=rv64imafdc`, `--with-abi=lp64d`
- Multilib set:
  - `rv64if-lp64f-rv64ifd-c`
  - `rv64iaf-lp64f-rv64imaf,rv64iafc-d`
  - `rv64imf-lp64f-rv64imfd-c`
  - `rv64imafc-lp64f-rv64imafdc-`
  - `rv64ifd-lp64d--m,c`
  - `rv64iafd-lp64d-rv64imafd,rv64iafdc-`
  - `rv64imafdc-lp64d--`

### X-HEEP / Core-V Custom (`xcv*`)

#### `xheep-base`
- Default: `--with-arch=rv32imc_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip`, `--with-abi=ilp32`
- Multilib set:
  - `rv32im_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip-ilp32--`
  - `rv32imc_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip-ilp32--`

#### `xheep-float`
- Default: `--with-arch=rv32imfc_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip`, `--with-abi=ilp32f`
- Multilib set:
  - `rv32imf_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip-ilp32f--`
  - `rv32imfc_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip-ilp32f--`

#### `xheep-zfinx`
- Default: `--with-arch=rv32imc_zfinx_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip`, `--with-abi=ilp32`
- Multilib set:
  - `rv32im_zfinx_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip-ilp32--`
  - `rv32imc_zfinx_xcvhwlp_xcvmem_xcvmac_xcvbi_xcvalu_xcvsimd_xcvbitmanip-ilp32--`

## How to Use

### 1a. Manually Generate the Toolchains

1. Go to the **Actions** tab in this repository.
2. Select the workflow.
3. Click **Run workflow** to start the compilation.

### 1b. Automatically Generate the Toolchains

The workflow starts automatically on the **1st of every month at 2:00 AM UTC** to keep the toolchains up to date.

### 2. Download and Install on the Target Board

1. Go to the **Releases** section of this repository and open the `latest` release.
2. Download the appropriate `.tar.gz` archive for your board’s architecture and desired flavor.

#### armhf artifacts
- `riscv-toolchain-armhf-rv32e.tar.gz`
- `riscv-toolchain-armhf-rv32i-imac.tar.gz`
- `riscv-toolchain-armhf-rv32-float.tar.gz`
- `riscv-toolchain-armhf-rv64i-imac.tar.gz`
- `riscv-toolchain-armhf-rv64-float.tar.gz`
- `riscv-toolchain-armhf-xheep-base.tar.gz`
- `riscv-toolchain-armhf-xheep-float.tar.gz`
- `riscv-toolchain-armhf-xheep-zfinx.tar.gz`

#### aarch64 artifacts
- `riscv-toolchain-aarch64-rv32e.tar.gz`
- `riscv-toolchain-aarch64-rv32i-imac.tar.gz`
- `riscv-toolchain-aarch64-rv32-float.tar.gz`
- `riscv-toolchain-aarch64-rv64i-imac.tar.gz`
- `riscv-toolchain-aarch64-rv64-float.tar.gz`
- `riscv-toolchain-aarch64-xheep-base.tar.gz`
- `riscv-toolchain-aarch64-xheep-float.tar.gz`
- `riscv-toolchain-aarch64-xheep-zfinx.tar.gz`

3. Transfer the `.tar.gz` file to your board.
4. Extract the archive to the root directory:
   ```bash
   sudo tar -xzvf riscv-toolchain-<arch>-<flavor>.tar.gz -C /
