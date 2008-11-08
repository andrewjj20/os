#include <sys_types64.h>
#include <types64.h>
#include <boot_info.h>
#include <sys_func.h>
#include <video.h>
#include <mem_manage.h>
#include <mp_spec_info.h>

//prints information sent by the bootloader
void bl_info()
{
	cons_write("Bootloader magic: ",18);
	write_numh(bootloader_magic);
	if(bootloader_info->flags & 0x200)
	{
		cons_writes("\nBootloader name: ");
		cons_writes((char *)((u_int64_t)bootloader_info->bootloader_name));
		cons_writes("\n");
	}
	else
		cons_writes("Bootloader name not found\n");
	cons_writes("Bootloader flags: ");
	write_numh(bootloader_info->flags);
	cons_writes("\n");

	if(bootloader_info->flags & 1)
	{
		cons_writes("Upper memory size:");
		write_numd(bootloader_info->mem_upper);
		cons_write("\n",1);

		cons_writes("Lower memory size:");
		write_numd(bootloader_info->mem_lower);
		cons_write("\n",1);
	}
	print_mmap_info();
}

void panic(char * k_string)
{
	cons_writes(k_string);
	asm volatile ( "hlt" );
}

extern void * desct_begin;
extern u_int64_t * kernel_page;

extern void * kern_start;
extern u_int32_t * head_magic;
extern u_int64_t init_page_table_lvl4[];
void test_neg_space()
{
	u_int64_t hmagic = 0xFFFFC00000000000;
	u_int32_t magic;

	cons_writes("Positive space PML4: ");
	write_numh(init_page_table_lvl4[0]);
	cons_writes("\nNegitive space PML4: ");
	write_numh(init_page_table_lvl4[(hmagic >> 39)& 0x1FF]);
	hmagic += (u_int64_t) head_magic;

	cons_writes("\nHeader offset from start:");
	write_numh(hmagic);

	cons_writes("\nlocation of header magic in negative space:\n");
	write_numh(hmagic);

	cons_writes("\nHeader magic in negative address space: ");
	magic = *((u_int32_t *) hmagic);
	write_numh(magic);

	/*
	write_numh(*((u_int32_t *) hmagic));
	*/
	cons_writes("\n");
}

//recieves execution from the assembly boot section
void kernel_start()
{
	u_int64_t * lvl3 = kernel_page;
	u_int64_t * lvl2 = kernel_page;
	u_int64_t * lvl1 = kernel_page;
	init_video();
	cons_write("Hello World\n",12);
	cons_write("it's Josh's os\n",15);
	bl_info();
	isr_init();

	test_neg_space();
	//init_mm();
	//find_print_mp_ptr();
}
