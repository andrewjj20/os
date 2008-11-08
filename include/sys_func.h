#ifndef __sys_func_h__
#define __sys_func_h__

 void outb(u_int16_t port,u_int8_t data);
 u_int8_t inb(u_int16_t port);
 void * memsetw(void * mem, u_int16_t data, size_t size);
 void * memmove(void *dest, void * src, size_t n);
 void * memmovew(void *dest, void * src, size_t n);
 size_t findb(void * src,u_int8_t data,size_t n);
 u_int64_t min(u_int64_t a, u_int64_t b);
 u_int64_t max(u_int64_t a, u_int64_t b);
 size_t strlen(const char *);
char * strstrn_n(char * hay, size_t n_h, char * needle, size_t n_n);
void isr_init();
void * memset(void *,int,size_t);
int strncmp(const char *, const char *,size_t n);

#define hlt_cpu			\
({				\
	asm volatile("hlt");	\
})

#endif
