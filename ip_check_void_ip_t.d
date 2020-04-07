#!/usr/sbin/dtrace -s

#pragma D option quiet

ip:::send,
ip:::receive
{
	/* Run this and grep for [^048c]$ */
	printf("%a\n", arg2);
}
