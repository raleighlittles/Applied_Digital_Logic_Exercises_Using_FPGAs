`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2019 11:57:34 PM
// Design Name: 
// Module Name: 
// Project Name: Code used for the 4-bit ripple counter project, originally from 4.2.1
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


module MyDTypeFFV2(
    input clk,
    input D,
    output reg Q = 0,
    output NQ
    );
    
    always @(posedge clk)
        begin
            Q <= D;
        end
   
   assign NQ = ~Q;
   
endmodule
