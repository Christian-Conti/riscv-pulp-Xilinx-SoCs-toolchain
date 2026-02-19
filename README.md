# PULP RISC-V GCC Toolchain for Xilinx SoCs

This repository automates the build process of the [PULP RISC-V GNU Toolchain](https://github.com/pulp-platform/pulp-riscv-gnu-toolchain) specifically for **ARM32 hosts**, such as the Xilinx PYNQ-Z2 board.

## Features
* **Automated Builds:** Trigger the build manually or let the scheduled Cron job keep the compiler up to date automatically.
* **Ready-to-use Artifact:** Outputs a compressed `.tar.gz` package that can be instantly deployed on the target board.

## How to Use

### 1a. Manually Generate the Toolchain
1. Go to the **Actions** tab in this repository.
2. Select the **Build RISC-V PULP Toolchain for Xilinx SoCs** workflow.
3. Click **Run workflow** to start the compilation.

### 1b. Automatically Generate the Toolchain
1. Each 1st of the month at 2am the workflow starts automatically.

### 2. Install on the PYNQ Board
1. Once the Action completes successfully, scroll down to the "Artifacts" section and download `riscv-pulp-toolchain-xilinx.zip`.
2. Transfer the zip file to your PYNQ board.
3. Unzip the file and extract the internal `.tar.gz` archive to your preferred installation directory.
4. Add the toolchain to your system's PATH:
   ```bash
   export PATH=/opt/pulp-riscv/bin:$PATH
