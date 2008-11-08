#include "types64.h"
#include "video.h"
#include "sys_func.h"

u_int16_t curs;

u_int16_t * video_base = (u_int16_t *) 0x00B8000;
char color = 0x07;
#define WIDTH 80
#define HEIGHT 25

void update_cursor()
{
	outb(0x3d4,14);
	outb(0x3D5,(char)(curs >> 8));
	outb(0x3d4,15);
	outb(0x3D5,(char)curs);
}

void init_video()
{
	memsetw(video_base,0x07<<8 | ' ',WIDTH * HEIGHT);
	curs = 0;
	update_cursor();
}
inline void scroll()
{
	memmovew(video_base,video_base + WIDTH,WIDTH * (HEIGHT - 1));
	bzero(video_base + WIDTH * (HEIGHT - 1),sizeof(u_int16_t) * WIDTH);
}

void mov_cursor(u_int64_t x,u_int64_t y)
{
	curs = y * WIDTH + x;
	update_cursor();
}

size_t cons_writes(char * s)
{
	return cons_write(s,strlen(s));
}
u_int64_t cons_write(char * src,size_t size)
{
	char * i;
	for(i = src ; i < src + size;++i)
	{
		cons_writeb(i,src + size - i);
	}
	return size;
}

size_t cons_writeb(int8_t * c, size_t len)
{
	outb(0x3F8,*c);
	switch(*c)
	{
		case '\n':
			curs += WIDTH - (curs % WIDTH);
			break;
		default:
			video_base[curs] = (color << 8) | *c;
			++curs;
	}
	if(curs >= WIDTH * HEIGHT)
	{
		scroll();
		curs -= WIDTH;
	}
	update_cursor();
	return 1;
}

void write_numh(u_int64_t in)
{
	char num[19] = {0};
	char * start;
	int place;

	for(place = 17; place != -1; --place)
	{
		num[place] = in % 16;
		if(num[place] < 10)
			num[place] += '0';
		else
			num[place] += 'A' - 10;
		in /= 16;
	}
	for(start = num + 2; start != num + 17 && *start == '0'; ++start);
	start -= 2;
	start[0] = '0';
	start[1] = 'x';
	cons_writes(start);
}

void write_numd(u_int64_t in)
{
	char num[30] = {'0','x',0};
	char * start;
	int place;

	for(place = 28; place != -1 ; --place)
	{
		num[place] = in % 10;
		num[place] += '0';
		in /= 10;
	}
	for(start = num; start != num + 28 && *start == '0'; ++start);
	cons_writes(start);
}
