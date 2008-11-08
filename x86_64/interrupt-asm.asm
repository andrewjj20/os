[BITS 64]
;this manages all of the interrupts, it is meant to handle most things 
%include "sys_const.asm"

%macro save 2-*

%rep %0
%rotate 1
push %1
%rotate 1
%endrep

%endmacro

%macro unsave 2-*
%rep %0
%rotate -1
push %1
%endrep

%endmacro

global isr
global idtd
extern int_rcv

[section .text]

isr:
	save	rax,rbx,rcx,rdx,rsi,rbp,r8,r9,r10,r11,r12,r13,r14,r15
	mov rsi,rsp
	call int_rcv
	unsave	rax,rbx,rcx,rdx,rsi,rbp,r8,r9,r10,r11,r12,r13,r14,r15
	pop rdi
	iret

[section .data]
idtd:
resw 1
resd 1

