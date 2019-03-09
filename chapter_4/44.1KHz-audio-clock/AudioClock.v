`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2019 12:49:14 PM
// Design Name: 
// Module Name: AudioClock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  The implementation of the audio clock device. See Figure 4.14
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AudioClock(
    input clk,
    output reg audio_clk
    );
    
    reg [9:0] count;
    
    /*
    To figure out the counter value, take the input clock frequency (100 MHz ,
    in this case) and divide it by the desired frequency (44.1 KHz in this case). 
    The value (hereafter referred to as C) resulting from that computation will give you 
    the number of clock cycles for which the audio signal must be LOW, and when the
    counter reaches the value of C, then set the audio signal to HIGH, and reset the
    counter back to 0.
    */
    always @(posedge clk)
        begin
            if (count < 2267)
            begin
                //audio_clk <= 1;
                //count <= 0;
                count <= count + 1;
                audio_clk <= 0;
            end
            
            else begin
                audio_clk <= 1;
                count <= 0;
            end
        end
    
endmodule
