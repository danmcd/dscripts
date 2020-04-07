pid$target:route::entry{ a[probefunc] = timestamp;}
pid$target:route::return
/ a[probefunc] /
{ 
            printf("%s: %d\n", probefunc, timestamp - a[probefunc]);
                    a[probefunc] = 0;
}

