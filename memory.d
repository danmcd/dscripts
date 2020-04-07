#!/usr/sbin/dtrace -s 
#pragma D option quiet 

pid$target::malloc:entry 
{
   self->size = arg0;
}

pid$target::malloc:return 
/self->size/
{
   addresses[arg1] = 1;
   /* print details of the allocation */
   /* seq_id;event;tid;address;size;datetime */
  printf("<__%i;%Y;%d;new;0x%x;%d;\n",
   i++, walltimestamp, tid, arg1, self->size);
   ustack(50);
   printf("__>\n\n");
   @mem[arg1] = sum(1);
   self->size=0;
}

pid$target::free:entry 
/addresses[arg0]/
{
   @mem[arg0] = sum(-1);
   /* print details of the deallocation */
   /* seq_id;event;tid;address;datetime */
   printf("<__%i;%Y;%d;delete;0x%x__>\n",
   i++, walltimestamp, tid, arg0);
}

END
{
   printf("== REPORT ==\n\n");
   printa("0x%x => %@u\n",@mem);
}
