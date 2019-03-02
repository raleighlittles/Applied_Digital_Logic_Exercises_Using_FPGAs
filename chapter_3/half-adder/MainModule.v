`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 02:44:33 PM
// Design Name: 
// Module Name: 
// Project Name: Half adder project from section 3.2.1.
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
    output[3:0] an,
    output [6:0] seg,
    output [15:0] led
    );
    
    // If a switch is on, turn the LED for that switch on
    assign led = sw;

    wire [15:0] half_adder_output;     
    
    HalfAdder MyHalfAdder(
                            .a (sw[0]),
                            .b (sw[1]),
                            .sum (half_adder_output[0]),
                            .carry (half_adder_output[1])
                        );
    
    HexDisplayV2 myHexDisplay( .clk (clk),
                                .value_in (half_adder_output),
                                .BCD_enable (~btnC),
                                .Display_Enable (1'b1),
                                .seg (seg),
                                .an (an)
                                );
    
endmodule
