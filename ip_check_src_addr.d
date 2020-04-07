#!/usr/sbin/dtrace -s

#pragma D option quiet

ip:::receive
/ *(uint8_t *)arg2 >> 4 == 4 /
{
        addr = (uintptr_t)&((ipha_t *)arg2)->ipha_src;
        printf("%a\n", addr);
/*
        printf("%s\n", inet_ntoa((ipaddr_t *)addr));
*/

}
ip:::receive
/ *(uint8_t *)arg2 >> 4 == 6 /
{
        addr = (uintptr_t)&((ip6_t *)arg2)->ip6_src;
        printf("%a\n", addr);
/*
        printf("%s\n", inet_ntoa6((in6_addr *)addr));
*/

}


/*
	ver = *(uint8_t *)arg2 >> 4;
        addr = (ver == 4 ? (uintptr_t)&((ipha_t *)arg2)->ipha_src : (uintptr_t)&((ip6_t *)arg2)->ip6_src);
        printf("%a\n", addr);
*/
