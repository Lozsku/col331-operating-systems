#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

/* System Call Definitions */
int 
sys_set_sched_policy(void)
{
    // Implement your code here 
    int set_var_myproc;
    int taken_arg=argint(0, &set_var_myproc);
    if(taken_arg < 0 || (set_var_myproc != 0 && set_var_myproc != 1))
        return -22;

    myproc()->policy = set_var_myproc;

    return 0;
}

int 
sys_get_sched_policy(void)
{
    // Implement your code here 
   return myproc()->policy;
}
