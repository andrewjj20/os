#!/usr/bin/perl
#

open(ISRS,">x86_64/isrs.asm");

printf ISRS "extern isr\n[section .isr]\n";

for($i = 0; $i < 256; ++$i)
{
	printf ISRS "isr$i:\n";
	printf ISRS "\tpush rdi\n\tmov rdi,$i\n\tjmp isr\n\n";
}

printf ISRS "[section .data]\n";
printf ISRS "global isrs\n";
printf ISRS "isrs:\n";

for( $i = 0; $i < 256; ++$i)
{
	printf ISRS "dq isr$i\n";
}

