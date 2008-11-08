#ifndef __boot_info_h__
#define __boot_info_h__

#include "types64.h"

struct boot_info
{
	u_int32_t flags;
	u_int32_t mem_lower;
	u_int32_t mem_upper;
	u_int32_t boot_device;
	u_int32_t cmdline;
	u_int32_t mods_count;
	u_int32_t mods_addr;
	u_int32_t sys[4];
	u_int32_t mmap_length;
	u_int32_t mmap_addr;
	u_int32_t drives_length;
	u_int32_t drives_addr;
	u_int32_t config_table;
	u_int32_t bootloader_name;
	u_int32_t apm_table;
	u_int32_t vbe_info[6];
} __attribute__ ((__packed__));

struct memory_map
{
	u_int32_t size;
	u_int64_t base;
	u_int64_t length;
	u_int32_t type;
} __attribute__ ((__packed__));

extern u_int32_t bootloader_magic;
extern struct boot_info * bootloader_info;

#endif

