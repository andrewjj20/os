%include "sys_const.asm"

extern text,bss,end
extern kernel_start

global gdt
global kernel_page
global bootloader_magic
global bootloader_info
global multiboot_header
global start32
global start64
global init_page_table_lvl4
global start

[section .header]
start:
jmp start32

align 4

;the header used by the bootloader
multiboot_header:

dd 0x1badb002
dd 0x10003
dd -(0x1badb002 + 0x10003)
dd multiboot_header
dd text
dd bss
dd end
dd start32
resd 4

[section .stext]
[BITS 32]
start32:

mov [bootloader_magic],eax
mov [bootloader_info],ebx

;set the global descriptor table
lgdt [gdt_desc]

;set the new data segment
mov ax,0x08
mov ds,ax
mov es,ax
mov fs,ax
mov gs,ax
mov ss,ax

jmp dword __kernel_cs:flush_gdt

flush_gdt:
mov esp, end_stack

;set up paging
mov eax, cr4
bts eax,5
;bts eax,4
mov cr4,eax
mov eax,init_page_table_lvl4
mov cr3,eax

;enable long mode
mov ecx, 0xC0000080
rdmsr
bts eax,8
wrmsr

;enable paging
mov eax,cr0
bts eax,31
mov cr0,eax


;enter long mode
jmp dword 011000b:start64

[BITS 64]
start64:

mov eax,init_page_table_lvl4
mov cr3,rax

;load the new gdt
lgdt [gdt_desc]

;load our own temporary stack
mov rsp, end_stack

xor rbx,rbx

mov ebx,[bootloader_info]
mov [bootloader_info],rbx
mov rax,init_page_table_lvl4
mov [kernel_page],rax

call kernel_start
hlt

[section .sdata]

gdt_desc:
dw gdt_end - gdt - 1
dq gdt
align 4096

;map the first 6MB of memory with identitiy pages
init_page_table_lvl4:
dq init_page_table_lvl3 + 7
resq 383
dq init_page_table_lvl3 + 7
resq 128

align 4096

init_page_table_lvl3:
dq init_page_table_lvl2 + 7
resq 511

align 4096

init_page_table_lvl2:
%assign mem 0 
%rep 20
dq mem | 010000111b
%assign mem mem + 2*1024*1024
%endrep
resq 1
dq stk_page_table_lvl1 + 0x7
resq 490
align 4096

stk_page_table_lvl1:
dq mem - (2 * 1024 * 1024) + 4096 * 1024 + 0x7
resq 511

gdt:
	dq 0x0							;null descriptor
	db 0xFF,0xFF,0x0,0x0,0x00,010010010b,011001111b,0x0	;Kernel DS
	db 0xFF,0xFF,0x0,0x0,0x00,010011010b,011001111b,0x0	;Kernel CS - 32
	db 0xFF,0xFF,0x0,0x0,0x00,010011010b,010101111b,0x0	;Kernel CS - 64
	db 0xFF,0xFF,0x0,0x0,0x00,010110010b,011001111b,0x0	;User DS
	db 0xFF,0xFF,0x0,0x0,0x00,010111010b,011001111b,0x0	;User CS - 32
	db 0xFF,0xFF,0x0,0x0,0x00,010111010b,010101111b,0x0	;User CS - 64
	dq 0,0
gdt_end:

[section .sbss]
bootloader_magic resd 1
bootloader_info	resq 1
kernel_page resq 1

stack:
resq 256
end_stack:

