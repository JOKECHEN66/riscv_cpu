	.section .sdata,"aw"
	.section .sbss,"aw",@nobits
	.globl  ip2
	.section  .sbss
	.align  2
	.type ip2, @object
	.size ip2, 20
ip2:
	.zero 20
	.text
	.align 1
	.globl gcd
	.type gcd, @function
gcd:
	sd ra,-8(sp)
	sd fp,-16(sp)
	addi fp,sp,-16
	addi sp,sp,-16
	addi sp,sp,-32
	mv t0,a0
	sw t0,-4(fp)
	mv t0,a1
	sw t0,-8(fp)
	sw s1,-12(fp)
	sw s2,-16(fp)
	sw s3,-20(fp)
_IF_5:
	lw s1,-8(fp)
	addi t0, zero, 0
	sub t1, s1, t0
	seqz t1, t1
	bnez t1, _IF_5_tmp
	la t0, _ELSE_5
	jr t0
_IF_5_tmp:
	lw s1,-4(fp)
	mv a0, s1
	la t0, gcd_EXIT_
	jr t0
	la t0, _EXIT_5
	jr t0
_ELSE_5:
_EXIT_5:
	lw s1,-4(fp)
	lw s2,-8(fp)
	div t0, s1, s2
	lw s3,-24(fp)
	mv s3, t0
	mv a0,s2
	mul t0, s3, s2
	sub t1, s1, t0
	mv a1,t1
	call gcd
	mv t0, a0
	mv a0, t0
	sw s3,-24(fp)
	la t0, gcd_EXIT_
	jr t0
gcd_EXIT_:
	lw s3,-20(fp)
	lw s2,-16(fp)
	lw s1,-12(fp)
	ld ra,8(fp)
	addi sp,fp,16
	ld fp,0(fp)
	jr ra
	.size gcd, .-gcd
	.text
	.align 1
	.globl _start_MAIN
	.type _start_MAIN, @function
_start_MAIN:
	fmv.w.x ft0,zero
	sd ra,-8(sp)
	sd fp,-16(sp)
	addi fp,sp,-16
	addi sp,sp,-16
	addi sp,sp,-32
	sw s1,-4(fp)
	sw s2,-8(fp)
	addi t0, zero, 5
	sw t0,-12(fp)
	addi t0, zero, 0
	sw t0,-24(fp)
	addi t0, zero, 2
	addi t1, zero, 0
	mv t2,t1
	slli t2,t2,2
	lui t1,%hi(ip2)
	addi t1,t1,%lo(ip2)
	add t1,t1,t2
	sw t0,0(t1)
	addi t0, zero, 8
	addi t2, zero, 1
	mv t1,t2
	slli t1,t1,2
	lui t2,%hi(ip2)
	addi t2,t2,%lo(ip2)
	add t2,t2,t1
	sw t0,0(t2)
	addi t0, zero, 12
	addi t1, zero, 2
	mv t2,t1
	slli t2,t2,2
	lui t1,%hi(ip2)
	addi t1,t1,%lo(ip2)
	add t1,t1,t2
	sw t0,0(t1)
	addi t0, zero, 32
	addi t2, zero, 3
	mv t1,t2
	slli t1,t1,2
	lui t2,%hi(ip2)
	addi t2,t2,%lo(ip2)
	add t2,t2,t1
	sw t0,0(t2)
	addi t0, zero, 46
	addi t1, zero, 4
	mv t2,t1
	slli t2,t2,2
	lui t1,%hi(ip2)
	addi t1,t1,%lo(ip2)
	add t1,t1,t2
	sw t0,0(t1)
	addi t0, zero, 0
	mv t2,t0
	slli t2,t2,2
	lui t1,%hi(ip2)
	addi t1,t1,%lo(ip2)
	add t1,t1,t2
	lw t0,0(t1)
	lw s1,-16(fp)
	mv s1, t0
	addi t0, zero, 0
	lw s2,-20(fp)
	mv s2, t0
	sw s1,-16(fp)
	sw s2,-20(fp)
_FOR_6:
	lw s1,-20(fp)
	lw s2,-12(fp)
	sub t0, s1, s2
	sltz t0, t0
	bnez t0, _FOR_6_tmp
	la t0, _EXIT_6
	jr t0
_FOR_6_tmp:
	lw s1,-20(fp)
	mv t0,s1
	slli t0,t0,2
	lui t2,%hi(ip2)
	addi t2,t2,%lo(ip2)
	add t2,t2,t0
	lw t1,0(t2)
	mv a0,t1
	lw s2,-16(fp)
	mv a1,s2
	call gcd
	mv t0, a0
	mv s2, t0
	addi t0, zero, 1
	add t1, s1, t0
	mv s1, t1
	sw s1,-20(fp)
	sw s2,-16(fp)
	la t0, _FOR_6
	jr t0
_EXIT_6:
	lw s1,-16(fp)
	mv a0,s1
	la t0, _write_int
	jalr t0
	lui t0,%hi(.LC7)
	addi a0,t0,%lo(.LC7)
	call _write_str
_start_MAIN_EXIT_:
	lw s2,-8(fp)
	lw s1,-4(fp)
	ld ra,8(fp)
	addi sp,fp,16
	ld fp,0(fp)
	jr ra
	.size _start_MAIN, .-_start_MAIN
	.section .rodata
	.align 3
.LC7:
	.string "\n\000"
