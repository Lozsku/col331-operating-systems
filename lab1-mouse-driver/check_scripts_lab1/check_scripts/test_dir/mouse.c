// mouse.c

#include "types.h"
#include "defs.h"
#include "x86.h"
#include "mouse.h"
#include "traps.h"

#define WHL(condition, body) while(condition) { body }
#define msend mousewait_send()
#define mrecv mousewait_recv()

#define CHECK_AND_PRINT(flag, message) \
    if (data & flag) {                  \
        cprintf(message);\
        cprintf("\n"); \
    }

void mousewait_send(void){
    WHL((inb(MSSTATP) & 0x02) != 0 ,);
}


void mousewait_recv(void){
     WHL((inb(MSSTATP) & 0x01) == 0,);
}

void mousecmd(uchar cmd){
    msend;
    outb(MSSTATP, PS2MS);
    msend;
    outb(MSDATAP, cmd);  
    mrecv;
    
    uchar response = inb(MSDATAP); 
    if (response != MSACK) {
        cprintf("Mouse command failed\n");
        return;
    }
}


void mouseinit(void) {
    
    cprintf("Mouse has been initialized\n");

    msend;
    outb(MSSTATP, MSEN);
    
    msend;
    outb(MSSTATP, 0x20);  

    mrecv;
    uchar status = (inb(MSDATAP) | 0x02); 

    msend;
    outb(MSSTATP, 0x60);  

    msend;
    outb(MSDATAP, status);  

    mousecmd(0xF6);
    mousecmd(0xF4);
    ioapicenable(IRQ_MOUSE, 0);
}


void mouseintr(void) {
    mrecv;
    uchar data;
    data = inb(MSDATAP); 

    CHECK_AND_PRINT(0x01, "LEFT");
    CHECK_AND_PRINT(0x02, "RIGHT");
    CHECK_AND_PRINT(0x04, "MID");
}


