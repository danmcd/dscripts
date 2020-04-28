#!/usr/sbin/dtrace -s 

BEGIN {
	total_bits = 0;
}

tcp:::receive 
/* Filter on a specific NGZ
/args[2]->ip_daddr == "10.77.77.100"/
*/
{
	this->bits = (args[2]->ip_plength - args[4]->tcp_offset) * 8;

	@bits[args[2]->ip_saddr, args[4]->tcp_dport] = sum(this->bits);
	total_bits = total_bits + this->bits;

}

tcp:::send {
	this->bits = (args[2]->ip_plength - args[4]->tcp_offset) * 8;
    @bits[args[2]->ip_daddr, args[4]->tcp_sport] = sum(this->bits);
}

profile:::tick-1sec {
	printf("\n   %-32s %16s\n", "HOST", "Bits/s");
	printa("   %-32s %@16d\n", @bits);
	printf("\n   %-32s %16d\n", "Total", total_bits);

	trunc(@bits);
	total_bits = 0;
}
