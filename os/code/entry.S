# 进程切换，保存原进程上下文
# 在保存进程上下文时，将传入的base后面的30个寄存器的值全部保存下来
.macro reg_save base
	sw ra, 0(\base)
	sw sp, 4(\base)
	sw gp, 8(\base)
	sw tp, 12(\base)
	sw t0, 16(\base)
	sw t1, 20(\base)
	sw t2, 24(\base)
	sw s0, 28(\base)
	sw s1, 32(\base)
	sw a0, 36(\base)
	sw a1, 40(\base)
	sw a2, 44(\base)
	sw a3, 48(\base)
	sw a4, 52(\base)
	sw a5, 56(\base)
	sw a6, 60(\base)
	sw a7, 64(\base)
	sw s2, 68(\base)
	sw s3, 72(\base)
	sw s4, 76(\base)
	sw s5, 80(\base)
	sw s6, 84(\base)
	sw s7, 88(\base)
	sw s8, 92(\base)
	sw s9, 96(\base)
	sw s10, 100(\base)
	sw s11, 104(\base)
	sw t3, 108(\base)
	sw t4, 112(\base)
	sw t5, 116(\base)
	# t6寄存器不在此进行保存，放在了switch_to函数中进行保存
.endm

# 切换的进程结束后，恢复上一个进程的上下文
# 在恢复进程上下文时，将保存下来的寄存器值写入到传入的寄存器的后面
.macro reg_restore base
	lw ra, 0(\base)
	lw sp, 4(\base)
	lw gp, 8(\base)
	lw tp, 12(\base)
	lw t0, 16(\base)
	lw t1, 20(\base)
	lw t2, 24(\base)
	lw s0, 28(\base)
	lw s1, 32(\base)
	lw a0, 36(\base)
	lw a1, 40(\base)
	lw a2, 44(\base)
	lw a3, 48(\base)
	lw a4, 52(\base)
	lw a5, 56(\base)
	lw a6, 60(\base)
	lw a7, 64(\base)
	lw s2, 68(\base)
	lw s3, 72(\base)
	lw s4, 76(\base)
	lw s5, 80(\base)
	lw s6, 84(\base)
	lw s7, 88(\base)
	lw s8, 92(\base)
	lw s9, 96(\base)
	lw s10, 100(\base)
	lw s11, 104(\base)
	lw t3, 108(\base)
	lw t4, 112(\base)
	lw t5, 116(\base)
	lw t6, 120(\base)
.endm

# Something to note about save/restore:
# 使用mscratch寄存器来保存上一个进程的指针，使用t6寄存器来作为上述两个函数的基址寄存器(因为其位置在最下面，一般不会被覆写)

#  mscratch寄存器用于机器模式下的程序临时保存某些数据。
# mscratch寄存器可以提供一种快速的保存、恢复机制。
# 比如，在进入机器模式的异常处理程序后，将应用程序的某个通用寄存器的值临时存入mscratch寄存器中，
# 然后在退出异常处理程序之前，将mscratch寄存器中的值读出恢复至通用寄存器。

.text

# void switch_to(struct context *next);
# a0指向下个task
.globl switch_to
.align 4
switch_to:
	csrrw	t6, mscratch, t6	# 交换t6和mscratch
	beqz	t6, 1f			# 如果t6为0(上个task为空)，则跳转到下面的第98行
	reg_save t6			# 调用上面声明的函数来保存上个task的上下文

	# Save the actual t6 register, which we swapped into
	# mscratch
	mv	t5, t6		# t5 points to the context of current task
	csrr	t6, mscratch
	sw	t6, 120(t5)	# 这里的120是offset，即保存t5+120位置的值

1:
	# 将下个任务的指针(a0)放到mscratch中
	csrw	mscratch, a0

	# 根据a0来恢复上下文
	mv	t6, a0
	reg_restore t6
	ret

.end

