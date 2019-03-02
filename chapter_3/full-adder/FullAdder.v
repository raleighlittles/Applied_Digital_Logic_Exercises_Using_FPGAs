`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 07:50:25 PM
// Design Name: 
// Module Name: FullAdder
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


module FullAdder(
    input a,
    input b,
    input carry_in,
    output wire sum,
    output wire carry_out
    );
    
    // Make a truth table for a full-adder
    // Notice that Carry_out = (A or B) and (A or C_in) and (B or C_in)
    // Sum = A xor B xor C
    
    // You can also make a full adder out of half adders too which is pretty cool honestly
    
    assign sum = a ^ b ^ carry_in;
    
    assign carry_out = (a | b) & (a | carry_in) & (b | carry_in);
    
endmodule
