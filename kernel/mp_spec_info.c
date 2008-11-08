#include <mp_spec_info.h>
#include <sys_func.h>

struct mp_pointer * find_print_mp_ptr()
{
	struct mp_pointer * ptr;

	ptr = find_mp_ptr();
	print_mp_ptr(ptr);
	return ptr;
}
struct mp_pointer * find_mp_ptr()
{
	u_int16_t * bms = (u_int16_t *)0x413;
	u_int16_t * ebda_start = (u_int16_t *)0x40E;
	struct mp_pointer * ret = 0;
	cons_writes("Base Memory Size: ");
	write_numd(*bms);
	cons_writes("\nStart of the EBDA: ");
	write_numh(*ebda_start);
	cons_writes("\n");
	if(!(ret = (struct mp_pointer *)
				strstrn_n((char *)((u_int64_t)*ebda_start),0x400,
					"_MP_",4)))
		ret = (struct mp_pointer *)
			strstrn_n((char *)0xE0000,0x20000,
				"_MP_",4);
	return ret;
}

void print_mp_ptr(struct mp_pointer * ptr)
{
	cons_writes("Found MP Pointer at");
	write_numh(ptr);
	cons_writes("\n");
	cons_write(ptr->sig,4);
	cons_writes("\nChecksum: ");
	write_numh(ptr->cksum);
	cons_writes("\nReversion: ");
	write_numd(ptr->spec_rev);
	cons_writes("\nType: ");
	write_numh(ptr->f_byte[0]);

	if(ptr->f_byte[0] == 0)
	{
		struct mp_tbl_header * tbl_hdr = (u_int64_t) ptr->pointer;
		cons_writes("\nMP Table Info:\n");
		cons_writes("Reversion: ");
		write_numd(tbl_hdr->spec_rev);
		cons_writes("\nOEM: ");
		cons_write(tbl_hdr->oem,8);
		cons_writes("\nProduct: ");
		cons_write(tbl_hdr->prod,12);
		cons_writes("\nLocal APIC address:");
		write_numh(tbl_hdr->lapic_addr);
		cons_writes("\n");
	}
}
