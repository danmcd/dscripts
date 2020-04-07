#!/usr/sbin/dtrace -s
#pragma D option quiet


tcp:::send,tcp:::receive
{
	printf("%d\n", args[3]->tcps_cwnd);
}
