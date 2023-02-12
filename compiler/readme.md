# RISC-V-Complier
一个简略版的RISC-V编译器，编程语言为类C语言，即C语言的子集。  
按照作业要求，设计的编程语言与编译器能够实现的功能如下：
1. 支持数组，实现数组求最大公约数算法（gcd.c）。 
2. 实现快速排序（quicksort.c）。 
3. 实现图算法中的最短路径算法（dijkstra.c）。

# 环境配置
1. 系统：Ubuntu 22.04
2. 安装依赖包 ：sudo apt-get install flex bison
3. 安装riscv64-toolchain  
(1) 安装跨平台工具 :  
sudo apt install libc6-riscv64-cross  
(2) 安装riscv64-linux-gnu-gcc :  
sudo apt install binutils-riscv64-linux-gnu  
sudo apt install gcc-riscv64-linux-gnu  
(3) 安装riscv64-unknown-elf-gcc :  
sudo apt install binutils-riscv64-unknown-elf  
sudo apt install gcc-riscv64-unknown-elf  
(4) 验证 ：  
riscv64-linux-gnu-gcc --version  
riscv64-unknown-elf-gcc --version  
若输出版本且不报错，则安装成功  
4. 安装qemu :  
(1) 安装编译所需的依赖包 :  
sudo apt install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev pkg-config  libglib2.0-dev libpixman-1-dev libsdl2-dev git tmux python3 python3-pip ninja-build  
(2) 下载源码包 :  
wget https://download.qemu.org/qemu-7.0.0.tar.xz  
tar xvJf qemu-7.0.0.tar.xz  
(3) 编译安装并配置 RISC-V 支持 :  
cd qemu-7.0.0  
./configure --target-list=riscv64-softmmu,riscv64-linux-user  
make -j$(nproc)  
(4) 配置环境变量 :  
vim ~/.bashrc  
在文件末尾添加: export PATH=(qemu-7.0.0/build的路径)  
(5) 验证 ：  
qemu-system-riscv64 --version   
qemu-riscv64 --version  
若输出版本且不报错，则安装成功  

# 文件说明：
src---包含词法分析器和语法分析器等工具文件  
test---求数组最大公约数、快排、最短路的类C语言实现  
begin.sh---脚本文件  
analysis.sh---脚本文件  
run.sh---脚本文件  

# 运行步骤：
在RISC-V-Complier目录下，命令行执行：  
`cd src`     
`sh ../begin.sh`    
`cd ../`  
`sh analyse.sh ./test/类C代码`    
例如 ：sh analyse.sh ./test/gcd.c   
命令行执行该步骤后，主目录中生成output.s文件，即为转换的汇编文件。
