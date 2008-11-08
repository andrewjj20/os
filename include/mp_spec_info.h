#ifndef __mp_spec_info_h__
#define __mp_spec_info_h__

#include "types64.h"

struct mp_pointer
{
	char sig[4];
	u_int32_t pointer;
	u_int8_t length;
	u_int8_t spec_rev;
	u_int8_t cksum;
	u_int8_t f_byte[5];
} __attribute__ ((__packed__));

struct mp_tbl_header
{
	char sig[4];
	u_int16_t btbl_len;
	u_int8_t spec_rev;
	u_int8_t cksum;
	char oem[8];
	char prod[12];
	u_int32_t tbl_ptr;
	u_int16_t tbl_size;
	u_int16_t entry_count;
	u_int32_t lapic_addr;
	u_int16_t etbl_len;
	u_int8_t etbl_cksum;
	u_int8_t res;
} __attribute__ ((__packed__));

struct mp_pointer * find_print_mp_ptr();

struct mp_pointer * find_mp_ptr();

void print_mp_ptr(struct mp_pointer *);

#endif
