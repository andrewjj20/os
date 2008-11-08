#include "types64.h"
#include "sys_func.h"

 void outb(u_int16_t port,u_int8_t data)
{
	asm volatile("out %%ax,%%dx"
		     :
		     :"d" (port),"a"(data)
		    );
}
 u_int8_t inb(u_int16_t port)
{
	u_int8_t ret;
	asm volatile("in %%dx,%%ax"
		     :"=a" (ret)
		     :"d" (port)
		    );
	return ret;
}

 void * memsetw(void * mem, u_int16_t data, size_t size)
{
	asm volatile ("rep stosw"
		      :
		      :"D" (mem), "a" (data), "c" (size)
		      );
	return mem;
}

 void * memmove(void *dest, void * src, size_t n)
{
	asm volatile ("rep movsb"
		      :
		      :"D" (dest), "S" (src), "c" (n)
		     );
	return dest;
}

 void * memmovew(void *dest, void * src, size_t n)
{
	asm volatile ("rep movsw"
		      :
		      :"D" (dest), "S" (src), "c" (n)
		     );
	return dest;
}

 size_t findb(void * src,u_int8_t data,size_t n)
{
	size_t loc;
	asm volatile ("repne scasb"
		      :"=c" (loc)
		      :"D"(src),"a"(data),"c" (n)
		     );
	return n - loc;
}

 u_int64_t min(u_int64_t a, u_int64_t b)
{
	if(a < b)
		return a;
	else
		return b;
}

 u_int64_t max(u_int64_t a, u_int64_t b)
{
	if(a > b)
		return a;
	else
		return b;
}
int strncmp(const char * s1, const char * s2,size_t n)
{
	size_t s = n;
	asm volatile ("repe cmpsb"
		     : "=c" (s)
		     : "S" (s1), "D" (s2), "c" (n)
		     );
	if(n == 0)
		return 0;
	return s1[n - s - 1] - s2[n - s - 1];
}
char * strstrn_n(char * hay, size_t n_h, char * needle, size_t n_n)
{
	char * hay_end = hay + n_h;
	char * needle_end = needle + n_n;

	if(n_h == 0 || n_n == 0)
		return 0;

	for(;hay < hay_end;++hay)
	{
		if(strncmp(hay,needle,n_n) == 0)
		{
			return hay;
		}
	}
	return 0;
}
inline void * memset(void * s,int c,size_t n)
{
	asm volatile ("rep stosb"
		     :
		     :"D" (s), "a" (c), "c" (n)
		     );
}
