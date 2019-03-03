`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Raleigh Littles
// 
// Create Date: 03/02/2019 12:48:01 AM
// Design Name: 
// Module Name: 
// Project Name: The 8-bit adder project from 3.2.3
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


module MainModule(
    input clk,
    input btnC,
    input [15:0] sw,
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg
    );
    
   assign led = sw;

    
    wire [7:0] A = sw[7:0];
    wire [7:0] B = sw[15:8];
    
    wire [15:0] Q; // sum bits
    wire [15:0] C; // carry out bits
    
    // Least significant bit only requires a half adder, not a full one. 
    // Rather than import the half adder module, just use the full adder
    // with the "carry in" bit set to 0.
    
    FullAdder Bit0Adder( .a (A[0]),
                         .b (B[0]),
                         .carry_in (1'b0),
                         .sum (Q[0]),
                         .carry_out (C[1])
                         );
                         
    FullAdder Bit1Adder( .a (A[1]),
                         .b (B[1]),
                         .carry_in (C[1]),
                         .sum(Q[1]),
                         .carry_out (C[2])
                         );
    
    FullAdder Bit2Adder( .a (A[2]),
                          .b (B[2]),
                          .carry_in (C[2]),
                          .sum (Q[2]),
                          .carry_out (C[3])
                          );
    
    FullAdder Bit3Adder( .a (A[3]),
                         .b (B[3]),
                         .carry_in (C[3]),
                         .sum (Q[3]),
                         .carry_out(C[4])
                         );
                         
    
    
    FullAdder Bit4Adder( .a (A[4]),
                         .b (B[4]),
                         .carry_in (C[4]),
                         .sum (Q[4]),
                         .carry_out (C[5])
                         );
    
    
    FullAdder Bit5Adder( .a(A[5]),
                         .b(B[5]),
                         .carry_in (C[5]),
                         .sum (Q[5]),
                         .carry_out (C[6])
                         );
    
    FullAdder Bit6Adder( .a (A[6]),
                         .b (B[6]),
                         .carry_in (C[6]),
                         .sum (Q[6]),
                         .carry_out (C[7])
                         );
    
    FullAdder Bit7Adder( .a (A[7]),
                         .b (B[7]),
                         .carry_in (C[7]),
                         .sum (Q[7]),
                         .carry_out(1'b0)
                         );
                         
    
    
    HexDisplayV2 Display( .clk (clk),
                          .value_in (Q),
                          .BCD_enable(~btnC),
                          .Display_Enable (1'b1),
                          .seg (seg),
                          .an (an)
                          );
     
    
endmodule
