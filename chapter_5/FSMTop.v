`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2019 12:42:18 PM
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Top level module for the Finite State Machine project.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FSMTop(
    input clk,
    input [7:0] JB,
    input btnC,
    input btnR,
    output [6:0] seg,
    output [3:0] an
    );
    
    wire oneshot_output;
    OneShotV4 OneShotEvents ( .clk (clk),
                              .asynctrigger_in (JB[1]),
                              .pulse_out (oneshot_output)
                              );
                              
  wire [31:0] event_counter_output;
  
  SyncEventCounterV1 MySyncEventCounter ( .clk (clk),
                                          .event_trigger (oneshot_output),
                                          .reset (btnR),
                                          .events_counted(event_counter_output)
                                          );
                                          
  HexDisplayV2 myHexDisplay ( .clk (clk),
                              .BCD_enable( ~btnC),
                              .Display_Enable('b1),
                              .seg (seg),
                              .an (an),
                              .value_in (event_counter_output)
                              );
                              
  
    
endmodule
