/* 
 * Trace the attachment of usbecm driver 
 * This needs to be run with -A "e.g. dtrace -AFs usbecm.d"
 * Then after reboot, consume anonymous tracing data with "dtrace -ae"
 */

#pragma D option flowindent

BEGIN
{
        printf("RUI: Tracing started");
}

fbt::usbecm_attach:entry
{
        self->trace = 1;
}

fbt:::
/self->trace/
{ }

fbt::usbecm_attach:return
{
        self->trace = 0;
        printf("usbecm_attach returned: %d\n", arg0);
}

