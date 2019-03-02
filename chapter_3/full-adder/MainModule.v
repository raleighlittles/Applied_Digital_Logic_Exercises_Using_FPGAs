`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 07:59:11 PM
// Design Name: 
// Module Name: MainModule
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


module MainModule(
    input clk,
    input [15:0] sw,
    input btnC,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
    );
    
    // Illuminate LEDs for 'on' switches
    assign led = sw;
    
    wire [15:0] full_adder_output;
    
    FullAdder MyFullAdder(
                            .a (sw[0]),
                            .b (sw[1]),
                            .carry_in (sw[2]),
                            .sum (full_adder_output[0]),
                            .carry_out (full_adder_output[1])
                          );
                          
    HexDisplayV2 MyHexDisplay( .clk (clk),
                                 .value_in (full_adder_output),
                                 .BCD_enable (~btnC),
                                 .Display_Enable (1'b1),
                                 .seg (seg),
                                 .an (an)
                               ); 
    
endmodule
