#ifndef __mem_manage_h__
#define __mem_manage_h__
#include "types64.h"

struct mem_info
{
	int free	:1;
	//size and length of this part of memory
	void * start;
	size_t length;
	//neighbors in physical memory
	struct mem_info * next;
	struct mem_info * prev;
	//next item in the stack
	struct mem_info * stk_next;
};

struct page
{
	u_int64_t present	:1;
	u_int64_t r_w		:1;
	u_int64_t u_s		:1;
	u_int64_t pwt		:1;
	u_int64_t pcd		:1;
	u_int64_t accessed	:1;
	u_int64_t dirty	:1;
	u_int64_t pat		:1;
	u_int64_t global	:1;
	u_int64_t av2		:3;
	u_int64_t ptr	:40;
	u_int64_t av1		:11;
	u_int64_t no_ex	:1;
};

void print_mmap_info();
void init_mm();
void * alloc(size_t);
void * alloc_page(size_t length);
void free_page(void *);
void * map_page_to_phys(void * base, size_t * length);
int chk_page_addr(u_int64_t);
#endif

