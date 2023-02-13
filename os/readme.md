### 调试环境配置

   - Ubuntu 20.04

   - ```shell
     sudo apt update
     ```

   - ```shell
     sudo apt install build-essential gcc make perl dkms git gcc-riscv64-unknown-elf gdb-multiarch qemu-system-misc
     ```

之后再git clone项目代码，在 ```./os/code``` 目录下面先make，再make run即可。