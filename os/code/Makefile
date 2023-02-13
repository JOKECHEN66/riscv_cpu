# common toolchain
CROSS_COMPILE = riscv64-unknown-elf-

QEMU = qemu-system-riscv32

# 指定目标架构（-march=rv32imc）和 ABI（-mabi=ilp32）
CFLAGS = -nostdlib -fno-builtin -march=rv32imc -mabi=ilp32 -g -Wall
QFLAGS = -nographic -smp 1 -machine virt -bios none

# 定义了包含工具和实用程序名称的变量，C 编译器（CC）、对象复制实用程序（OBJCOPY）和对象转储实用程序（OBJDUMP）
GDB = gdb-multiarch
CC = ${CROSS_COMPILE}gcc
OBJCOPY = ${CROSS_COMPILE}objcopy
OBJDUMP = ${CROSS_COMPILE}objdump

SRCS_ASM = \
	start.S \
	mem.S \
	entry.S \

SRCS_C = \
	kernel.c \
	uart.c \
	printf.c \
	sched.c \
	user.c \

OBJS = $(SRCS_ASM:.S=.o)
OBJS += $(SRCS_C:.c=.o)

.DEFAULT_GOAL := all
all: os.elf

# start.o must be the first in dependency!
os.elf: ${OBJS}
	${CC} ${CFLAGS} -T os.ld -o os.elf $^
	${OBJCOPY} -O binary os.elf os.bin

%.o : %.c
	${CC} ${CFLAGS} -c -o $@ $<

%.o : %.S
	${CC} ${CFLAGS} -c -o $@ $<

# make 规则
# make run的时候将os.elf丢到模拟器中跑
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
	rm -rf *.o

