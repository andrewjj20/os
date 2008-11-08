#ifndef __video_h__
#define __video_h__

#include "types64.h"

void init_video();
void mov_cursor(u_int64_t x,u_int64_t y);
size_t cons_writes(char *);
size_t cons_write(char *,size_t);
size_t cons_writeb(int8_t * c, size_t len);
void write_numh(u_int64_t in);
void write_numd(u_int64_t in);

#endif
