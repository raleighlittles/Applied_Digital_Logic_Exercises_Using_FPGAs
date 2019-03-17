`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2019 03:19:45 PM
// Design Name: 
// Module Name: PWMAudioPlayerTop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PWMAudioPlayerTop(
    input clk,
    input JC2,
    output JC0,
    output JC1,
    output JC3,
    output [7:0] JB
    );
    
    wire audio_clk_output;
    wire [23:0] address_counter_output;
    
    AudioClock MyAudioClock( .clk (clk),
                             .audio_clk ( audio_clk_output)
                             );
                   
    AddressCounter MyAddressCounter  ( .clk (audio_clk_output),
                                    .my_counter (address_counter_output)
                                    );
                                    
    wire [7:0] flash_data;
                                    
    ReadOneByteV3 MyReadOneByte ( .clk (clk),
                                 .enable (audio_clk_output),
                                 .address (address_counter_output),
                                 .Q (JC2),
                                 .NCS ( JC0),
                                 .D (JC1),
                                 .clk_out (JC3),
                                 .data( flash_data) );
                                 
   SimplePWM MySimplePWMVerilog ( .clk_in (clk),
                                  .x_in (flash_data),
                                  .pwm_out (JB)
                                  );
                               
    
endmodule
