`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2019 12:06:26 AM
// Design Name: 
// Module Name: SyncEventCounterV1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// The project from section 5.3.2. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SyncEventCounterV1(
    input clk,
    input event_trigger,
    input reset,
    output reg [31:0] events_counted,
    // Note this next parameter is new and is not in the original implementation
    // from the earlier Chapter 5 project.
    output reg data_ready = 0
    );
    
        // ----- Begin copy of Language Template.
        // Taken from: Verilog/Synthesis Constructs/Coding Examples/State Machines/Moore/Binary (parameter)/Fast/4 States
       parameter STARTUP = 2'b00;
       parameter COUNTING = 2'b01;
       parameter STORE_COUNTS = 2'b10;
       parameter RESET_COUNTERS = 2'b11;
       
       parameter CLOCK_FREQUENCY = 100_000_000; // 100 MHz
       
       reg [1:0] state = STARTUP;
    
       reg [31:0] clock_cycles; // n
       reg [31:0] events_running_total;
     
    
       always @(posedge clk)
          if (reset) begin
             state <= STARTUP;
          end
          else
             case (state)
                STARTUP : begin
                   clock_cycles <= 0;
                   events_running_total <= 0;
                   data_ready <= 0;
                end
                COUNTING : begin
                // The concept of t_ref here is poorly explained in the book.
                   if (clock_cycles < CLOCK_FREQUENCY -1)
                   begin
                      state <= COUNTING;
                   end
                   
                   else if (clock_cycles == CLOCK_FREQUENCY-1)
                   begin
                      state <= STORE_COUNTS;
                   end
                      
                   if (event_trigger)
                   begin 
                      events_running_total <= events_running_total + 1;
                   end
                      
                   

                end
                STORE_COUNTS : begin
                   
                   events_counted <= events_running_total;

                end
                RESET_COUNTERS : begin
                   state <= COUNTING;
                   clock_cycles <= 0;
                   events_running_total <= 0;
                   events_counted <= events_counted;
                   data_ready <= 1'b1;
                end
             endcase
                                
                             
         // End copy of Language Template.   
    
endmodule
