/*
 * Usage:dtrace -q -s trace_lib_calls.d <library> `pgrep -o <process name>`
 */
#!/usr/sbin/dtrace -q -s 
pid$2:$1::entry
{
	printf("%d - %s(0x%x,0x%x, 0x%x, 0x%x)\n", $1, probefunc, arg1, arg2, arg3, arg4);
}

