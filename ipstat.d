#!/usr/sbin/dtrace -s
ip:::send
{
	ipha = (ipha_t *)(args[4]->ipv4_hdr);
	printf("%d.%d.%d.%d", 
		*(char *)&ipha->ipha_src,
		*((char *)(&ipha->ipha_src) + 1),
		*((char *)(&ipha->ipha_src) + 2),
		*((char *)(&ipha->ipha_src) + 3));

}
ip:::receive
{
	ipha = (ipha_t *)(args[4]->ipv4_hdr);
	printf("%d.%d.%d.%d", 
		*(char *)&ipha->ipha_dst,
		*((char *)(&ipha->ipha_dst) + 1),
		*((char *)(&ipha->ipha_dst) + 2),
		*((char *)(&ipha->ipha_dst) + 3));
}

