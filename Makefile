.SUFFIXES:
.SUFFIXES: .asm .o .c .o .c .s

SOURCES.c = kernel/kern_base.c kernel/video.c kernel/sys_func.c x86_64/interrupt.c kernel/mp_spec_info.c kernel/mem_manage.c
SOURCES.asm = x86_64/enable64.asm  x86_64/interrupt-asm.asm x86_64/isrs.asm
ASSEMBLY = $(SOURCES.c:.c=.s)
OBJCETS.c = 
OBJCETS.asm = 
OBJECTS = $(SOURCES.asm:.asm=.o) $(SOURCES.c:.c=.o)

all : kern

.asm.o: 
	yasm -o $@ -f elf64 $<

.c.o:
	gcc ${CPPFLAGS} -o $@ -I./include -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -c $<
.c.s:
	gcc ${CPPFLAGS} -o $@ -I./include -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -S $<

x86_64/isrs.asm:isrmkr.pl
	./isrmkr.pl

kern: $(OBJECTS) link.ld
	ld -T link.ld -o kern $(OBJECTS)

asm: $(ASSEMBLY)

clean_asm :
	rm -f $(ASSEMBLY)

clean :
	rm -f  kern $(OBJECTS) $(ASSEMBLY)
