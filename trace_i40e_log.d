#!/usr/sbin/dtrace -Cs

#include <sys/stream.h>

fbt::cprintf:entry,
fbt::log_makemsg:entry,
fbt::console_printf:entry,
fbt::log_enter:entry
{
	self->inlog=1;
	printf("%s: \n", probefunc); stack();
}

fbt::canput:entry
/self->inlog/
{
	printf("%s: \n", probefunc); stack();
}

fbt::putq:entry
/self->inlog/
{
	self->inlog = 0;
	printf("%s: \n", probefunc); stack();
}
fbt::log_makemsg:entry 
{
	printf("send message %s \n ", stringof(args[5])); 
	stack();
}

fbt::log_sendmsg:entry
{
	this->msg = (mblk_t *)args[0];
	printf("sendmsg: %s\n", stringof(this->msg->b_cont->b_rptr));
}


