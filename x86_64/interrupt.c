#include <types64.h>
#include <sys_func.h>
#include <interrupt.h>
struct __attribute__ ((__packed__)) isr
{
	u_int16_t offset_ll;
	u_int16_t selector;
	u_int8_t ist;
	u_int8_t flags;
	u_int16_t offset_lh;
	u_int32_t offset_high;
	u_int32_t reserved0;
} ;

struct __attribute__ ((__packed__)) mp_float_p
{
	char sig[4];
	u_int32_t ptr;
	u_int8_t len;
	u_int8_t rev;
	u_int8_t cksum;
	u_int8_t features[5];
};

typedef void (*isr_t) (void *);

void * find_MP();
void init_leg_irq();
void init_apic();
void idt_inst();

struct isr idt[256];
isr_t isr_funs[256];
extern struct isr_tbl_desc idtd;
extern u_int64_t isrs[];

extern u_int64_t isr_entry_size;

void GP_Fault(void *);

void def_int()
{
	panic("kernel panic, run away interrupt on the loose");
}

// initialize pic and install the idt
void isr_init ()
{	
	idt_inst();
	//asm volatile ("int $0x80" ::);
}

void idt_inst()
{
	size_t i;
	for(i = 0; i < 256; ++i)
	{
		idt[i].offset_ll = isrs[i];
		idt[i].selector = 0x18;
		idt[i].ist = 0;
		idt[i].flags = 0x8E;
		idt[i].offset_lh = (u_int16_t)(isrs[i] >> 16);
		idt[i].offset_high = (u_int32_t) (isrs[i] >> 32);
		idt[i].reserved0 = 0;
		isr_funs[256] = 0;
	}
	idtd.size = sizeof( struct isr ) * 256 - 1;
	idtd.addr = (u_int64_t)&idt;
	lidt();

	isr_funs[13] = &GP_Fault;
}

void int_rcv(long int vec,struct isr_stk * int_info)
{
	if(isr_funs[vec] == 0)
	{
		cons_writes("Interrupt ");
		write_numd(vec);
		cons_writes(" called\n");
		cons_writes("No Handler Found, Halting the CPU!!!!");
		hlt_cpu;
	}
	isr_funs[vec](int_info);
}

void GP_Fault(void * i)
{
	struct isr_err_stk * info = (struct isr_err_stk *) i;
	cons_writes("General Protection Fault\n");
	cons_writes("Error: ");
	write_numh(info->err_code);
	cons_writes("\nHalting the CPU");
	hlt_cpu;
}

