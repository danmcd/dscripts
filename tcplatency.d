#!/usr/sbin/dtrace -s

/*
 * Timestamp of tcp-send aggregated by connection id and tcp next sequence
 */
tcp:::send
{
        seq[args[1]->cs_cid, args[3]->tcps_snxt] = timestamp;
}

/* 
 * Dropped packets broken down by remote address
 */
tcp:::send
/  args[3]->tcps_retransmit /
{
        @b[args[3]->tcps_raddr] = count();
}

/*
 * Index into the seq[] aggregation by connection id and the received ack.
 * Admittedly there are some holes here that need to be cleaned up to get 
 * exact latency measurements.
 */
tcp:::receive
/ seq[args[1]->cs_cid, args[4]->tcp_ack] /
{
        self->sentt = seq[args[1]->cs_cid, args[4]->tcp_ack];
        @a[args[3]->tcps_raddr] = quantize(timestamp - self->sentt);

} 
