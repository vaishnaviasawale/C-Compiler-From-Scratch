	.file	"test3.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"plus"
	.type	"plus", @function
"plus":
.LFB0:
	.cfi_startproc
	lea	eax, [rdi+rsi]
	ret
	.cfi_endproc
.LFE0:
	.size	"plus", .-"plus"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	"main"
	.type	"main", @function
"main":
.LFB1:
	.cfi_startproc
	mov	eax, 7
	ret
	.cfi_endproc
.LFE1:
	.size	"main", .-"main"
	.ident	"GCC: (GNU) 16.1.1 20260515 (Red Hat 16.1.1-2)"
	.section	.note.GNU-stack,"",@progbits
