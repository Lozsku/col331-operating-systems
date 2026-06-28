// mouse.c

#include "types.h"
#include "defs.h"
#include "x86.h"
#include "mouse.h"
#include "traps.h"



// Wait until the mouse controller is ready for us to send a packet
void 
mousewait_send(void) 
{
    while ((inb(MSSTATP) & 0x02) != 0);
}

// Wait until the mouse controller has data for us to receive
void 
mousewait_recv(void) 
{
    while ((inb(MSSTATP) & 0x01) == 0)
        ; // Wait until bit 0 of port 0x64 is set
}

// Send a one-byte command to the mouse controller, and wait for it
// to be properly acknowledged
void 
mousecmd(uchar cmd) 
{
    mousewait_send();
    outb(MSSTATP, PS2MS);  // Tell the controller we're addressing the mouse
    mousewait_send();
    outb(MSDATAP, cmd);     // Send the command byte
    mousewait_recv();
    
    uchar response = inb(MSDATAP); // Read the acknowledgment
    if (response != MSACK) {
        cprintf("Mouse command failed\n");
        return;
    }
}


void mouseinit(void) {
    // Step 1: Wait until the controller can receive a command
    cprintf("Mouse has been initialized\n");

    mousewait_send();
    
    // Step 2: Enable the mouse by sending 0xA8 to the control port
    outb(MSSTATP, MSEN);
    

    // Step 3: Modify the Compaq Status Byte to enable interrupts
    mousewait_send();
    outb(MSSTATP, 0x20);  // Select the Compaq Status byte
    mousewait_recv();
    uchar status = (inb(MSDATAP) | 0x02);  // Read the status byte and enable interrupts
    mousewait_send();
    outb(MSSTATP, 0x60);  // Tell the controller we're about to send the modified status byte
    mousewait_send();
    outb(MSDATAP, status);  // Send the modified status byte
    
    // Step 4: Set default settings for the mouse (0xF6)
    mousecmd(0xF6);

    // Step 5: Activate the mouse and start receiving interrupts (0xF4)
    mousecmd(0xF4);

    // Step 6: Enable mouse interrupts on CPU 0 (IRQ12)
    ioapicenable(IRQ_MOUSE, 0);
    }


void mouseintr(void) {
    uchar status;
    
    mousewait_recv();
    status = inb(MSDATAP);

    // Check if the buffer has data
    if (!(status & 0x01)) { 
        // return;
    }
    mousewait_recv();
    uchar data;
    data = inb(MSDATAP); // Read the data byte
    

    // Process mouse click events
    if (data & 0x01) {
        cprintf("LEFT\n");
    }
     if (data & 0x02) {
        cprintf("RIGHT\n");
    }
     if (data & 0x04) {
        cprintf("MID\n");
    }
}


// void mouseintr(void) {
//     uchar status;
//     uchar data;
//     cprintf("HI-7\n");
//     // Loop to drain the controller's buffer
//     while (1) {
//         mousewait_send();
//         outb(MSSTATP, 0x20);  // Get status byte
//         mousewait_recv();
//         status = inb(MSDATAP);
//         cprintf("HI-8\n");
//         // Check if the buffer has data
//         // if (!(status & 0x01)) {
//         //     break;  // No more data available
//         // }

//         // Read the first byte of the mouse packet
//         data = inb(MSDATAP);

//         // Check if it's a complete mouse packet (3 bytes)
//         if (status & 0x20) {
//             // Print messages based on mouse click events
//             if (data & 0x01) {
//                 cprintf("LEFT\n");
//             }
//             if (data & 0x02) {
//                 cprintf("RIGHT\n");
//             }
//             if (data & 0x04) {
//                 cprintf("MID\n");
//             }

//             // Read and discard the next two bytes (X and Y movement)
//             mousewait_recv();
//             inb(MSDATAP);
//             mousewait_recv();
//             inb(MSDATAP);
//         }
//     }
// }
