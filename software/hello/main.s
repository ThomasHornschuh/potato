	.file	"main.c"
	.text
	.align	2
	.globl	exception_handler
	.type	exception_handler, @function
exception_handler:
	ret
	.size	exception_handler, .-exception_handler
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	li	a5,-1073733632
	lui	a4,%hi(uart0)
	sw	a5,%lo(uart0)(a4)
	li	a4,16
	sw	a4,12(a5)
	lui	a4,%hi(.LC0)
	add	a4,a4,%lo(.LC0)
.L3:
	lbu	a2,0(a4)
	bnez	a2,.L5
	li	a0,0
	ret
.L5:
	lw	a3,8(a5)
	and	a3,a3,8
	bnez	a3,.L5
	sw	a2,0(a5)
	add	a4,a4,1
	j	.L3
	.size	main, .-main
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"Hello world\n\r"
	.section	.sbss,"aw",@nobits
	.align	2
	.type	uart0, @object
	.size	uart0, 4
uart0:
	.zero	4
	.ident	"GCC: (GNU) 6.1.0"
