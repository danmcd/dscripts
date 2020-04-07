#!/usr/sbin/dtrace -Cs

#pragma D option quiet

fbt:i40e:i40e_log:entry 
{
	self->in_i40e_log = 1;
}

fbt:i40e:i40e_log:return
{
	self->in_i40e_log = 0;
}

fbt::log_sendmsg:entry
/self->in_i40e_log/
{
	this->msg = (mblk_t *)args[0];
	printf("%Y %s\n", walltimestamp, stringof(this->msg->b_cont->b_rptr));
}

