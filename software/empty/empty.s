	.file	"empty.c"
	.text
	.align	2
	.globl	exception_handler
	.type	exception_handler, @function
exception_handler:
	ret
	.size	exception_handler, .-exception_handler
	.globl	__mulsi3
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	lw	a5,0(a1)
	add	sp,sp,-16
	sw	ra,12(sp)
	mv	a1,a0
	lbu	a0,0(a5)
	call	__mulsi3
	lw	ra,12(sp)
	add	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 6.1.0"
