#include <mem_manage.h>
#include <boot_info.h>
#include <video.h>
//bootstrap memory management
void fill_info_base();
struct mem_info* find_free_mem_info(size_t min_len);

struct mem_info * info_base; 
size_t info_base_len = 18;

volatile struct mem_info * free_mem_head = 0;

volatile struct mem_info * used_mem_head = 0;

extern char end;
extern u_int64_t page_size;

//Initialize the free memeory stacks
void init_mm()
{
}

//allocate memory
void * alloc(size_t len)
{
}

//called when a page needs to be allocated
void * alloc_page(size_t length)
{
	//not implemented
	panic("kernel panic, memory page management not implemented");
}

extern struct page * kernel_page;

/void print_mmap_info()
{
	if(bootloader_info->flags & 0x40)
	{
		int i;
		if(bootloader_info->mmap_length > 0)
		{
			cons_writes("\nmemory maps: ");
			write_numd(bootloader_info->mmap_length);
			u_int64_t place = bootloader_info->mmap_addr;
			u_int64_t end = place + bootloader_info->mmap_length;
			while(place < end)
			{
				struct memory_map * mmap = (struct memory_map *)place;
				cons_writes("\nmap size: ");
				write_numd(mmap->size);
				cons_writes("\nbase address: ");
				write_numh(mmap->base);
				cons_writes("\nlength: ");
				write_numd(mmap->length);
				cons_writes("\ntype: ");
				write_numd(mmap->type);
				//temporary shortcut
				place += mmap->size + 4;
			}
			cons_writes("\ndone\n");
		}
		else
		{
			cons_writes("\nmemory map has zero length\n");
			/*
			write_numh(bootloader_info->mmap_length);
			cons_writes("\n");
			write_numh(bootloader_info->mmap_addr);
			*/
		}
	}
	else
	{
		cons_writes("No memory map info");
	}
}
