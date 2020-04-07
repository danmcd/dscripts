#!/usr/sbin/dtrace -FCs


uintptr_t global_mp;

/*
 * Print the received PDU and start the trace
 *
 * CHANGE THE LAST BYTE to match your aggr
 *  dladm show-phys -m
 */
lacp_receive_sm:entry
/args[0]->lp_addr[5] == 0xc8/
{
    printf("\nReceived Packet:\n");
    /* TODO: get remote mac addr */
    print(*args[1]);
    self->trace = 1;
}

/*
 * Stop the trace
 */
lacp_receive_sm:return
/self->trace == 1/
{
        printf("Returns 0x%llx", arg1);
        self->trace = 0;
}

/*
 * Tracing functions
 * Uncomment to enable flow trace
::entry
/self->trace == 1/
{
}
::return
/self->trace == 1/
{
        printf("Returns 0x%llx", arg1);
}
 */


ixgbe_tx_copy:entry
/self->trace/
{
    printf("======================\n");
    print(*((struct ether_header *)((mblk_t *)arg2)->b_rptr));
    print(*(lacp_t *)(args[2]->b_rptr + 14));
    printf("======================\n");

}

/*
 * Track the packet to make sure it is freed in the writeback function
 */
mac_hwring_send_priv:entry 
/self->trace/
{
    global_mp = arg2;
    print(arg2);
}

fill_lacp_pdu:entry
/self->trace/
{
    self->pdu = args[1];
    printf("Sending Packet from:");
    print(args[0]->lp_addr);
}

fill_lacp_pdu:return
/self->trace && self->pdu/
{
    printf("\n=============================\n");
    print(*self->pdu);
    printf("\n=============================\n");
    self->pdu = NULL;
}

freeb:entry,
freemsg:entry
/global_mp != NULL && global_mp == arg0/
{
    printf("Freeing mp %x\n", arg0);
    @a[stack()] = count();
    print(*((struct ether_header *)((mblk_t *)arg0)->b_rptr));
    print(*(lacp_t *)(args[0]->b_rptr + 14));
    global_mp = NULL;
}

