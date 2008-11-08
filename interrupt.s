	.file	"interrupt.c"
	.section	.rodata
	.align 8
.LC0:
	.string	"kernel panic, run away interrupt on the loose"
	.text
.globl def_int
	.type	def_int, @function
def_int:
.LFB2:
	pushq	%rbp
.LCFI0:
	movq	%rsp, %rbp
.LCFI1:
	movl	$.LC0, %edi
	movl	$0, %eax
	call	panic
	leave
	ret
.LFE2:
	.size	def_int, .-def_int
.globl isr_init
	.type	isr_init, @function
isr_init:
.LFB3:
	pushq	%rbp
.LCFI2:
	movq	%rsp, %rbp
.LCFI3:
	movl	$0, %eax
	call	idt_inst
#APP
	int $0x80
#NO_APP
	leave
	ret
.LFE3:
	.size	isr_init, .-isr_init
.globl idt_inst
	.type	idt_inst, @function
idt_inst:
.LFB4:
	pushq	%rbp
.LCFI4:
	movq	%rsp, %rbp
.LCFI5:
	movq	$0, -16(%rbp)
	movl	$isr_start, %eax
	movq	%rax, -8(%rbp)
	jmp	.L6
.L7:
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	movl	%eax, %edx
	movq	%rcx, %rax
	salq	$4, %rax
	movw	%dx, idt(%rax)
	movq	-16(%rbp), %rax
	salq	$4, %rax
	movw	$24, idt+2(%rax)
	movq	-16(%rbp), %rax
	salq	$4, %rax
	movb	$0, idt+4(%rax)
	movq	-16(%rbp), %rax
	salq	$4, %rax
	movb	$-114, idt+5(%rax)
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	shrq	$16, %rax
	movl	%eax, %edx
	movq	%rcx, %rax
	salq	$4, %rax
	movw	%dx, idt+6(%rax)
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rax
	shrq	$32, %rax
	movl	%eax, %edx
	movq	%rcx, %rax
	salq	$4, %rax
	movl	%edx, idt+8(%rax)
	movq	-16(%rbp), %rax
	salq	$4, %rax
	movl	$0, idt+12(%rax)
	incq	-16(%rbp)
	movq	isr_entry_size(%rip), %rax
	addq	%rax, -8(%rbp)
.L6:
	cmpq	$255, -16(%rbp)
	jbe	.L7
	movw	$4095, idtd(%rip)
	movl	$idt, %eax
	movq	%rax, idtd+2(%rip)
#APP
	lidt idtd
#NO_APP
	leave
	ret
.LFE4:
	.size	idt_inst, .-idt_inst
	.section	.rodata
.LC1:
	.string	"Interrupt "
.LC2:
	.string	" called\n"
	.text
.globl int_rcv
	.type	int_rcv, @function
int_rcv:
.LFB5:
	pushq	%rbp
.LCFI6:
	movq	%rsp, %rbp
.LCFI7:
	subq	$16, %rsp
.LCFI8:
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$.LC1, %edi
	movl	$0, %eax
	call	cons_writes
	movq	-8(%rbp), %rdi
	movl	$0, %eax
	call	write_numd
	movl	$.LC2, %edi
	movl	$0, %eax
	call	cons_writes
#APP
	hlt
#NO_APP
	leave
	ret
.LFE5:
	.size	int_rcv, .-int_rcv
	.comm	idt,4096,32
	.section	.eh_frame,"a",@progbits
.Lframe1:
	.long	.LECIE1-.LSCIE1
.LSCIE1:
	.long	0x0
	.byte	0x1
	.string	"zR"
	.uleb128 0x1
	.sleb128 -8
	.byte	0x10
	.uleb128 0x1
	.byte	0x3
	.byte	0xc
	.uleb128 0x7
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x1
	.align 8
.LECIE1:
.LSFDE1:
	.long	.LEFDE1-.LASFDE1
.LASFDE1:
	.long	.LASFDE1-.Lframe1
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI0-.LFB2
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI1-.LCFI0
	.byte	0xd
	.uleb128 0x6
	.align 8
.LEFDE1:
.LSFDE3:
	.long	.LEFDE3-.LASFDE3
.LASFDE3:
	.long	.LASFDE3-.Lframe1
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI2-.LFB3
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI3-.LCFI2
	.byte	0xd
	.uleb128 0x6
	.align 8
.LEFDE3:
.LSFDE5:
	.long	.LEFDE5-.LASFDE5
.LASFDE5:
	.long	.LASFDE5-.Lframe1
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI4-.LFB4
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI5-.LCFI4
	.byte	0xd
	.uleb128 0x6
	.align 8
.LEFDE5:
.LSFDE7:
	.long	.LEFDE7-.LASFDE7
.LASFDE7:
	.long	.LASFDE7-.Lframe1
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI6-.LFB5
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI7-.LCFI6
	.byte	0xd
	.uleb128 0x6
	.align 8
.LEFDE7:
	.ident	"GCC: (GNU) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)"
	.section	.note.GNU-stack,"",@progbits
