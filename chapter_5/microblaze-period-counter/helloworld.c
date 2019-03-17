/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */


#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h" // add
#include "xiomodule.h" // add

volatile char int_flag = 0;    // millisecond counter variable
//function which is called by the GPI interrupt when one of its bits goes hi
void MyInterruptFlagSet( void* ref) {
  int_flag = 1; // when it receives interrupt, set c
}
int main()
{
    init_platform();
    u32 data;
    u16 my_secs = 0;
    XIOModule gpi;

    //print("Setting up GPI\n\r");
    data = XIOModule_Initialize(&gpi, XPAR_IOMODULE_0_DEVICE_ID);
    data = XIOModule_Start(&gpi);

    //setting up interrupt handlers and enables them
    microblaze_register_handler(XIOModule_DeviceInterruptHandler,
                                  XPAR_IOMODULE_0_DEVICE_ID); // register the interrupt handler
    // Makes the connection between the Id of the interrupt source and the associated handler that is to run when the interrupt is recognized.
    XIOModule_Connect(&gpi, XIN_IOMODULE_GPI_1_INTERRUPT_INTR, MyInterruptFlagSet,
                            NULL); // register timerTick() as our interrupt handler
    XIOModule_Enable(&gpi, XIN_IOMODULE_GPI_1_INTERRUPT_INTR); // enable the interrupt
    microblaze_enable_interrupts(); // enable global interrupts
    while (1)
    {
      while(int_flag == 0 )  //wait till interrupt flag goes high
            ;
      data = XIOModule_DiscreteRead(&gpi, 2); // read counts (channel 2)
        xil_printf("%d: %d\n\r",my_secs, data);
        my_secs++;
        int_flag = 0;  //clear flag
    }
    cleanup_platform();
    return 0;
}
