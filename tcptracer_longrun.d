#!/usr/sbin/dtrace -s
#pragma D option quiet
#pragma D option defaultargs
inline int TICKS=$1;
inline string ADDR=$$2;

dtrace:::BEGIN
{
       TIMER = ( TICKS != NULL ) ?  TICKS : 1 ;
       ticks = TIMER;
       walltime=timestamp;
       printf("starting up ...\n");

	printf("%8s %8s %8s %8s s|r %-8s  %8s %8s %8s  %8s %8s %12s %12s %12s %8s %8s  %s  \n", "unack", "unack", "delta", "Bytes", "Bytes", "send", "send", "receive", "receive", "congestion", "cwnd", "SACK", "SACK", "", "", "");
	printf("%8s %8s %8s %8s s|r %-8s  %8s %8s %8s  %8s %8s %12s %12s %12s %8s %8s  %s  \n", "B-tx", "B-rx", "us", "sent", "rx", "window", "wnd-scle", "window", "wnd-scle", "window", "thresh", "acked", "retrans", "RTTout", "Max seg", "retrans?");
}

tcp:::send
/     ( args[2]->ip_daddr == ADDR || ADDR == NULL ) /
{
    delta= timestamp-walltime;
    walltime=timestamp;
    printf("%8d %8d %8d %8d snd %8s  %8d %8d %8d  %8d %8d %12d %12d %12d %8d %8d  %d  \n",
        args[3]->tcps_snxt - args[3]->tcps_suna ,
        args[3]->tcps_rnxt - args[3]->tcps_rack,
        delta/1000,
        args[2]->ip_plength - args[4]->tcp_offset,
        "",
        args[3]->tcps_swnd,
        args[3]->tcps_snd_ws,
        args[3]->tcps_rwnd,
        args[3]->tcps_rcv_ws,
        args[3]->tcps_cwnd,
        args[3]->tcps_cwnd_ssthresh,
        args[3]->tcps_sack_fack,
        args[3]->tcps_sack_snxt,
        args[3]->tcps_rto,
        args[3]->tcps_mss,
        args[3]->tcps_retransmit
      );
}
tcp:::receive
/ ( args[2]->ip_saddr == ADDR || ADDR == NULL ) /
{
      delta=timestamp-walltime;
      walltime=timestamp;
      printf("%8d %8d %8d %8s rcv %-8d  %8d %8d %8d  %8d %8d %12d %12d %12d %8d %8d  %d  \n",
        args[3]->tcps_snxt - args[3]->tcps_suna ,
        args[3]->tcps_rnxt - args[3]->tcps_rack,
        delta/1000,
        "",
        args[2]->ip_plength - args[4]->tcp_offset,
        args[3]->tcps_swnd,
        args[3]->tcps_snd_ws,
        args[3]->tcps_rwnd,
        args[3]->tcps_rcv_ws,
        args[3]->tcps_cwnd,
        args[3]->tcps_cwnd_ssthresh,
        args[3]->tcps_sack_fack,
        args[3]->tcps_sack_snxt,
        args[3]->tcps_rto,
        args[3]->tcps_mss,
        args[3]->tcps_retransmit
      );
}

