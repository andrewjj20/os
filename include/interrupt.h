#ifndef __interrupt_h__
#define __interrupt_h__

struct __attribute__ ((__packed__)) isr_stk
{
	u_int64_t reg64[15];
	ptr_t ip;
	u_int8_t pad1[6];
	u_int16_t cs;
	u_int64_t flags;
	ptr_t sp;
	u_int8_t pad2[6];
	u_int16_t ss;
};

struct __attribute__ ((__packed__)) isr_err_stk
{
	u_int64_t reg64[15];
	u_int8_t pad1[4];
	u_int32_t err_code;
	ptr_t ip;
	u_int8_t pad2[6];
	u_int16_t cs;
	u_int64_t flags;
	ptr_t sp;
	u_int8_t pad3[6];
	u_int16_t ss;
};

struct __attribute__ ((__packed__)) isr_tbl_desc
{
	u_int16_t size;
	u_int64_t addr;
};

#define lidt()					\
{							\
	asm volatile ("lidt idtd" : :);	\
}

#endif

