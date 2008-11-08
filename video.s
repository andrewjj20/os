	.file	"video.c"
	.text
.globl outb
	.type	outb, @function
outb:
.LFB2:
	movl	%edi, %edx
	movl	%esi, %eax
#APP
	out %dx,%ax
#NO_APP
	ret
.LFE2:
	.size	outb, .-outb
.globl inb
	.type	inb, @function
inb:
.LFB3:
	movl	%edi, %edx
#APP
	in %ax,%dx
#NO_APP
	movzbl	%al, %eax
	ret
.LFE3:
	.size	inb, .-inb
.globl memsetw
	.type	memsetw, @function
memsetw:
.LFB4:
	movl	%esi, %eax
	movq	%rdx, %rcx
#APP
	rep stosw
#NO_APP
	movq	%rdi, %rax
	ret
.LFE4:
	.size	memsetw, .-memsetw
.globl memmove
	.type	memmove, @function
memmove:
.LFB5:
	movq	%rdx, %rcx
#APP
	rep movsb
#NO_APP
	movq	%rdi, %rax
	ret
.LFE5:
	.size	memmove, .-memmove
.globl memmovew
	.type	memmovew, @function
memmovew:
.LFB6:
	movq	%rdx, %rcx
#APP
	rep movsw
#NO_APP
	movq	%rdi, %rax
	ret
.LFE6:
	.size	memmovew, .-memmovew
.globl findb
	.type	findb, @function
findb:
.LFB7:
	movl	%esi, %eax
	movq	%rdx, %rcx
#APP
	repne scasb
#NO_APP
	subq	%rcx, %rdx
	movq	%rdx, %rax
	ret
.LFE7:
	.size	findb, .-findb
.globl min
	.type	min, @function
min:
.LFB8:
	cmpq	%rsi, %rdi
	movq	%rsi, %rax
	cmovbe	%rdi, %rax
	ret
.LFE8:
	.size	min, .-min
.globl max
	.type	max, @function
max:
.LFB9:
	cmpq	%rsi, %rdi
	movq	%rsi, %rax
	cmovae	%rdi, %rax
	ret
.LFE9:
	.size	max, .-max
.globl scroll
	.type	scroll, @function
scroll:
.LFB11:
	movq	video_base(%rip), %rdi
	leaq	160(%rdi), %rsi
	movl	$1920, %ecx
#APP
	rep movsw
#NO_APP
	ret
.LFE11:
	.size	scroll, .-scroll
.globl update_cursor
	.type	update_cursor, @function
update_cursor:
.LFB12:
	movl	$980, %edx
	movl	$14, %eax
#APP
	out %dx,%ax
#NO_APP
	movzwl	curs(%rip), %ecx
	movb	$-43, %dl
	movzbl	%ch, %eax
#APP
	out %dx,%ax
#NO_APP
	movb	$-44, %dl
	movl	$15, %eax
#APP
	out %dx,%ax
#NO_APP
	movb	$-43, %dl
	movl	%ecx, %eax
#APP
	out %dx,%ax
#NO_APP
	ret
.LFE12:
	.size	update_cursor, .-update_cursor
.globl cons_writeb
	.type	cons_writeb, @function
cons_writeb:
.LFB15:
	movzbl	(%rdi), %edx
	cmpb	$10, %dl
	jne	.L22
	movzwl	curs(%rip), %ecx
	movzwl	%cx, %eax
	imull	$52429, %eax, %eax
	shrl	$16, %eax
	shrw	$6, %ax
	movl	%eax, %edx
	sall	$4, %edx
	sall	$6, %eax
	addl	%eax, %edx
	subw	%dx, %cx
	movl	$80, %eax
	subw	%cx, %ax
	movw	%ax, curs(%rip)
	jmp	.L24
.L22:
	movzwl	curs(%rip), %ecx
	movsbl	color(%rip),%eax
	sall	$8, %eax
	movzbw	%dl, %dx
	orl	%eax, %edx
	movq	video_base(%rip), %rax
	movw	%dx, (%rax,%rcx,2)
	incw	curs(%rip)
.L24:
	movzwl	curs(%rip), %eax
	cmpw	$1999, %ax
	jbe	.L25
	movq	video_base(%rip), %rdi
	leaq	160(%rdi), %rsi
	movl	$1920, %ecx
#APP
	rep movsw
#NO_APP
	subl	$80, %eax
	movw	%ax, curs(%rip)
.L25:
	movl	$1, %eax
	ret
.LFE15:
	.size	cons_writeb, .-cons_writeb
.globl init_video
	.type	init_video, @function
init_video:
.LFB10:
	movq	video_base(%rip), %rdi
	movl	$1824, %eax
	movl	$2000, %ecx
#APP
	rep stosw
#NO_APP
	ret
.LFE10:
	.size	init_video, .-init_video
.globl mov_cursor
	.type	mov_cursor, @function
mov_cursor:
.LFB13:
	movq	%rsi, %rax
	salq	$4, %rax
	salq	$6, %rsi
	addq	%rsi, %rax
	leal	(%rax,%rdi), %ecx
	movw	%cx, curs(%rip)
	movl	$980, %edx
	movl	$14, %eax
#APP
	out %dx,%ax
#NO_APP
	movb	$-43, %dl
	movzbl	%ch, %eax
#APP
	out %dx,%ax
#NO_APP
	movb	$-44, %dl
	movl	$15, %eax
#APP
	out %dx,%ax
#NO_APP
	movb	$-43, %dl
	movl	%ecx, %eax
#APP
	out %dx,%ax
#NO_APP
	ret
.LFE13:
	.size	mov_cursor, .-mov_cursor
.globl cons_write
	.type	cons_write, @function
cons_write:
.LFB14:
	pushq	%rbx
.LCFI0:
	movq	%rdi, %r9
	leaq	(%rdi,%rsi), %rax
	cmpq	%rax, %rdi
	jae	.L42
	movl	$0, %r8d
	movl	$80, %ebx
	movl	$1920, %r11d
	movq	%rax, %r10
	subq	%rdi, %r10
.L35:
	movzbl	(%r8,%r9), %edx
	cmpb	$10, %dl
	jne	.L36
	movzwl	curs(%rip), %ecx
	movzwl	%cx, %eax
	imull	$52429, %eax, %eax
	shrl	$16, %eax
	shrw	$6, %ax
	movl	%eax, %edx
	sall	$4, %edx
	sall	$6, %eax
	addl	%eax, %edx
	subw	%dx, %cx
	movl	%ebx, %eax
	subw	%cx, %ax
	movw	%ax, curs(%rip)
	jmp	.L38
.L36:
	movzwl	curs(%rip), %ecx
	movsbl	color(%rip),%eax
	sall	$8, %eax
	movzbw	%dl, %dx
	orl	%eax, %edx
	movq	video_base(%rip), %rax
	movw	%dx, (%rax,%rcx,2)
	incw	curs(%rip)
.L38:
	movzwl	curs(%rip), %eax
	cmpw	$1999, %ax
	jbe	.L39
	movq	video_base(%rip), %rdi
	leaq	160(%rdi), %rsi
	movq	%r11, %rcx
#APP
	rep movsw
#NO_APP
	subl	$80, %eax
	movw	%ax, curs(%rip)
.L39:
	incq	%r8
	cmpq	%r10, %r8
	jne	.L35
.L42:
	popq	%rbx
	ret
.LFE14:
	.size	cons_write, .-cons_write
.globl video_base
	.data
	.align 8
	.type	video_base, @object
	.size	video_base, 8
video_base:
	.quad	753664
.globl color
	.type	color, @object
	.size	color, 1
color:
	.byte	7
	.comm	curs,2,2
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
	.align 8
.LEFDE1:
.LSFDE3:
	.long	.LEFDE3-.LASFDE3
.LASFDE3:
	.long	.LASFDE3-.Lframe1
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x0
	.align 8
.LEFDE3:
.LSFDE5:
	.long	.LEFDE5-.LASFDE5
.LASFDE5:
	.long	.LASFDE5-.Lframe1
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x0
	.align 8
.LEFDE5:
.LSFDE7:
	.long	.LEFDE7-.LASFDE7
.LASFDE7:
	.long	.LASFDE7-.Lframe1
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x0
	.align 8
.LEFDE7:
.LSFDE9:
	.long	.LEFDE9-.LASFDE9
.LASFDE9:
	.long	.LASFDE9-.Lframe1
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x0
	.align 8
.LEFDE9:
.LSFDE11:
	.long	.LEFDE11-.LASFDE11
.LASFDE11:
	.long	.LASFDE11-.Lframe1
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x0
	.align 8
.LEFDE11:
.LSFDE13:
	.long	.LEFDE13-.LASFDE13
.LASFDE13:
	.long	.LASFDE13-.Lframe1
	.long	.LFB8
	.long	.LFE8-.LFB8
	.uleb128 0x0
	.align 8
.LEFDE13:
.LSFDE15:
	.long	.LEFDE15-.LASFDE15
.LASFDE15:
	.long	.LASFDE15-.Lframe1
	.long	.LFB9
	.long	.LFE9-.LFB9
	.uleb128 0x0
	.align 8
.LEFDE15:
.LSFDE17:
	.long	.LEFDE17-.LASFDE17
.LASFDE17:
	.long	.LASFDE17-.Lframe1
	.long	.LFB11
	.long	.LFE11-.LFB11
	.uleb128 0x0
	.align 8
.LEFDE17:
.LSFDE19:
	.long	.LEFDE19-.LASFDE19
.LASFDE19:
	.long	.LASFDE19-.Lframe1
	.long	.LFB12
	.long	.LFE12-.LFB12
	.uleb128 0x0
	.align 8
.LEFDE19:
.LSFDE21:
	.long	.LEFDE21-.LASFDE21
.LASFDE21:
	.long	.LASFDE21-.Lframe1
	.long	.LFB15
	.long	.LFE15-.LFB15
	.uleb128 0x0
	.align 8
.LEFDE21:
.LSFDE23:
	.long	.LEFDE23-.LASFDE23
.LASFDE23:
	.long	.LASFDE23-.Lframe1
	.long	.LFB10
	.long	.LFE10-.LFB10
	.uleb128 0x0
	.align 8
.LEFDE23:
.LSFDE25:
	.long	.LEFDE25-.LASFDE25
.LASFDE25:
	.long	.LASFDE25-.Lframe1
	.long	.LFB13
	.long	.LFE13-.LFB13
	.uleb128 0x0
	.align 8
.LEFDE25:
.LSFDE27:
	.long	.LEFDE27-.LASFDE27
.LASFDE27:
	.long	.LASFDE27-.Lframe1
	.long	.LFB14
	.long	.LFE14-.LFB14
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI0-.LFB14
	.byte	0xe
	.uleb128 0x10
	.byte	0x83
	.uleb128 0x2
	.align 8
.LEFDE27:
	.ident	"GCC: (GNU) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)"
	.section	.note.GNU-stack,"",@progbits
