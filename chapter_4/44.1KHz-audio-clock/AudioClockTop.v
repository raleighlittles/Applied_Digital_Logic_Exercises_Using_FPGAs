`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2019 12:12:24 PM
// Design Name: 
// Module Name: AudioClockTop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// The top module for the 44.1 kHz clock project from section 4.4.3
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AudioClockTop(
    input clk,
    output [7:0] JB
    );
    
    AudioClock MyAudioClock (.clk (clk),
                            .audio_clk (JB[0])
                            );
    
endmodule
