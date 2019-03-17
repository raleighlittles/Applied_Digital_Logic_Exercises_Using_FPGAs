`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2019 05:23:21 PM
// Design Name: 
// Module Name: MicroblazeCounterTopModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// // The only new part about this project (compared to the other event counter),
// is the microblaze instantiation. See Figure 5.9.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MySyncCounterwUART (
    input clk,
    input [7:0] JB,
    input btnR,
    input btnC,
    output RsTx,
    output [6:0] seg,
    output [3:0] an
    );
    
//    //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
//    microblaze_mcs_0 your_instance_name (
//      .Clk(Clk),                        // input wire Clk
//      .Reset(Reset),                    // input wire Reset
//      .GPI1_Interrupt(GPI1_Interrupt),  // output wire GPI1_Interrupt
//      .INTC_IRQ(INTC_IRQ),              // output wire INTC_IRQ
//      .LMB_UE(LMB_UE),                  // output wire [0 : 0] LMB_UE
//      .LMB_CE(LMB_CE),                  // output wire [0 : 0] LMB_CE
//      .UART_rxd(UART_rxd),              // input wire UART_rxd
//      .UART_txd(UART_txd),              // output wire UART_txd
//      .GPIO1_tri_i(GPIO1_tri_i),        // input wire [0 : 0] GPIO1_tri_i
//      .GPIO2_tri_i(GPIO2_tri_i)        // input wire [31 : 0] GPIO2_tri_i
//    );
//    // INST_TAG_END ------ End INSTANTIATION Template ---------

    wire [31:0] event_counter_output;
    
    wire data_ready_output;
    
    wire oneshot_output;
    
    OneShotV4 OneShotEvents( .clk (clk),
                             .asynctrigger_in (JB[1]),
                             .pulse_out (oneshot_output)
                             );
                             
    
    SyncEventCounterV1  MySyncEventCounter ( .clk (clk) ,
                                             .event_trigger (oneshot_output),
                                             .reset (btnR),
                                             .events_counted(event_counter_output),
                                             .data_ready (data_ready_output)
                                             );
                                             
    HexDisplayV2 myHexDisplay ( .clk(clk),
                                .BCD_enable (~btnC),
                                .Display_Enable('b1),
                                .seg (seg),
                                .an (an),
                                .value_in(event_counter_output)
                                );
                                             
    
    
    microblaze_mcs_0 my_mb ( .Clk (clk),
                            .Reset (btnR),
                            .GPI1_Interrupt(),
                            .INTC_IRQ(),
                            .UART_txd(RsTx),
                            .GPIO1_tri_i(data_ready_output),
                            .GPIO2_tri_i(event_counter_output)
                            );
                            
                           
                           
    

endmodule
