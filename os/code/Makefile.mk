-------------------------------------
# common toolchain

CROSS_COMPILE = riscv64-unknown-elf-

# 指定目标架构（-march=rv32ima）和 ABI（-mabi=ilp32）
CFLAGS = -nostdlib -fno-builtin -march=rv32ima -mabi=ilp32 -g -Wall

QEMU = qemu-system-riscv32
QFLAGS = -nographic -smp 1 -machine virt -bios none

# 定义了包含工具和实用程序名称的变量，C 编译器（CC）、对象复制实用程序（OBJCOPY）和对象转储实用程序（OBJDUMP）
GDB = gdb-multiarch
CC = ${CROSS_COMPILE}gcc
OBJCOPY = ${CROSS_COMPILE}objcopy
OBJDUMP = ${CROSS_COMPILE}objdump



--------------------------------------
SRCS_ASM = \
	start.S \

SRCS_C = \
	kernel.c \

OBJS = $(SRCS_ASM:.S=.o)
OBJS += $(SRCS_C:.c=.o)

.DEFAULT_GOAL := all
all: os.elf

os.elf: ${OBJS}
	${CC} ${CFLAGS} -Ttext=0x80000000 -o os.elf $^
	${OBJCOPY} -O binary os.elf os.bin

%.o : %.c
	${CC} ${CFLAGS} -c -o $@ $<

%.o : %.S
	${CC} ${CFLAGS} -c -o $@ $<



--------------------------------------
// make规则
run: all
	@${QEMU} -M ? | grep virt >/dev/null || exit
	@${QEMU} ${QFLAGS} -kernel os.elf

.PHONY : debug
debug: all
	@${QEMU} ${QFLAGS} -kernel os.elf -s -S &
	@${GDB} os.elf -q -x ../gdbinit

.PHONY : code
code: all
	@${OBJDUMP} -S os.elf | less

.PHONY : clean
clean:
	rm -rf *.o *.bin *.elf