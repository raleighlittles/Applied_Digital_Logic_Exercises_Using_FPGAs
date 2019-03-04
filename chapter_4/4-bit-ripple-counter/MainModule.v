`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2019 12:04:49 AM
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
        input btnC, 
        output [15:0] led,
        output [3:0] an,
        output [6:0] seg
    );
    
    wire [4:0] Q;
    wire [4:0] NQ;
    
    
    // module for D-type flip flop (version 2), see section 4.2
    MyDTypeFFV2 FF0( .clk (btnC),
                 .D (NQ[0]),
                 .Q (Q[0]),
                 .NQ (NQ[0])
                 );
                 
     MyDTypeFFV2 FF1 ( .clk ( Q[0] ),
                       .D ( NQ[1] ),
                       .Q ( Q[1] ),
                       .NQ ( NQ[1] )
                       );
                       
                      
     MyDTypeFFV2 FF2 ( .clk ( Q[1] ),
                       .D ( NQ[2] ),
                       .Q ( Q[2] ),
                       .NQ ( NQ[2] )
                       );
                       
     MyDTypeFFV2 FF3 ( .clk ( Q[2] ),
                        .D ( NQ[3] ),
                        .Q ( Q[3] ),
                        .NQ ( NQ[3] )
                        );
                        
     HexDisplayV2 myHexDisplay( .clk (clk),
                                .value_in (Q),
                                .BCD_enable (1'b1),
                                .Display_Enable (1'b1),
                                .seg (seg),
                                .an (an)
                                );
    
    assign led = Q;
    
endmodule
