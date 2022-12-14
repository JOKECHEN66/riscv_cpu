### 调试环境配置

1. 常规配置

   - Ubuntu 20.04

   - ```shell
     sudo apt update
     ```

   - ```shell
     sudo apt install build-essential gcc make perl dkms git gcc-riscv64-unknown-elf gdb-multiarch qemu-system-misc
     ```

2. 使用docker（开箱即用、不污染本地环境，推荐）

   需要先安装docker，windows、Mac、Linux均可

   - ```docker pull zhugez/nj-lab```
   - ```docker run -dit --name os zhugez/nj-lab:latest```
   - ```docker exec -it os /bin/bash```



之后再git clone项目代码，在 ```./os/code``` 目录下面先make，再make run即可。