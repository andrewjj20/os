OUTPUT_FORMAT("binary")
ENTRY(start32)
begin = 0x100000;
SECTIONS
{
		/*
	.header begin : AT(begin)
	{
		LONG(0);
		LONG(0);
		multiboot_header = .;

		LONG(0x1badb002);
		LONG(0x10003);
		LONG(-(0x1badb002 + 0x10003));
		LONG(multiboot_header);
		LONG(text);
		LONG(bss);
		LONG(end);
		LONG(start32);
		. += 16;
	}
		*/
	.header begin :AT(begin)
	{
		text = .;
		*(.header)
		*(.isr)
		*(.stext)
		*(.sdata)
		*(.sbss)

		. = ALIGN(4096);
	}
	.text : AT(ADDR(.header) + SIZEOF(.header))
	{
		*(.text)
		. = ALIGN(4096);
	}
	.data : AT(ADDR(.header) + SIZEOF(.text) + SIZEOF(.header))
	{
		data = .;
		*(.data)
		*(.rodata)
		*(.gdtbl)
		page_size = .;
		QUAD(4096);

		int_table = .;
		*(.inttable)
		int_table_end = .;

		int_table_size = .;
		QUAD((int_table_end - int_table) / 16);

		kern_start = .;
		QUAD(text);
		head_magic = .;
		QUAD(multiboot_header);

		. = ALIGN(4096);
	}
	.bss : AT(ADDR(.header) + SIZEOF(.text) +SIZEOF(.data) + SIZEOF(.header))
	{
		bss = .;
		*(.bss)
		. = ALIGN(4096);
	}
	end = ADDR(.header) + SIZEOF(.text) + SIZEOF(.data) + SIZEOF(.bss) + SIZEOF(.header);
	/DISCARD/ :
	{
		*(.eh_frame)
	}
}

