`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 02:16:47 PM
// Design Name: 
// Module Name:  This is the half adder module used.
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


module HalfAdder(
    input a,
    input b,
    output wire sum,
    output wire carry
    );
    
    wire lsb;
    wire msb;
    
    assign lsb = a;
    assign msb = b;
    assign sum = a ^ b;
    assign carry = a & b;

endmodule
