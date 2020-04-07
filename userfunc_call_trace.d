#!/usr/sbin/dtrace -Cs 

#pragma D option flowindent

pid$1::$2:entry
{
    self->trace = 1;
}

pid$1::$2:return
/self->trace/
{
    self->trace = 0;
}

pid$1:::entry,
pid$1:::return
/self->trace/
{
}


/* 
 * If you want to limit the depth of the tracing add a module name to the probe
 * like so:
 */

/*
pid$1:nas.so::entry,
pid$1:nas.so::return
/self->trace/
{
}
*/

/* Or */

/*
pid$1:libak.so::entry,
pid$1:libak.so::return
/self->trace/
{
} 

