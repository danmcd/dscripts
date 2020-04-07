#!/usr/sbin/dtrace -Cs

/*
 * This is a workaround for non-existing function to convert number to string
 * in DTrace. Other possible workaround is to use an array.
 */
#define IF(a, b, c) ((a) ? (b) : (c))
#define INT2STR(i) \
	IF((i) == 0, "0", \
	IF((i) == 1, "1", \
	IF((i) == 2, "2", \
	IF((i) == 3, "3", \
	IF((i) == 4, "4", \
	IF((i) == 5, "5", \
	IF((i) == 6, "6", \
	IF((i) == 7, "7", \
	IF((i) == 8, "8", \
	IF((i) == 9, "9", \
	"X"))))))))))

fbt:ixgbe:ixgbe_m_start:entry,
fbt:ixgbe:ixgbe_m_stop:entry,
fbt:ixgbe:ixgbe_m_promisc:entry,
fbt:ixgbe:ixgbe_m_multicst:entry,
fbt:ixgbe:ixgbe_m_ioctl:entry
{
	self->ixgbep = (ixgbe_t *)arg0;
	@[probefunc, strjoin("ixgbe", INT2STR(self->ixgbep->instance)),
	    stack()] = count();
}
fbt:mac:mac_link_update:entry
{
	self->mip = (mac_impl_t *)arg0;
	printf("\n%Y mac_link_update(%s, %d)\n", walltimestamp,
	    self->mip->mi_name, arg1);
	printf("execname = %s pid = %d\n", execname, pid);
	stack();
/*	@[probefunc, self->mip->mi_name, stack()] = count(); */
}
tick-10s
{
	printf("\n%Y aggregation:\n", walltimestamp);
	printa(@);
	trunc(@);
}
