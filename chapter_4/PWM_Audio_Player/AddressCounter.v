`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2019 03:17:17 PM
// Design Name: 
// Module Name: AddressCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This is the module you have to create for Step 2 of the "Detailed Description" in section 4.6.2.

// Used to read the address in memory of the Flash part that contins the audio data.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AddressCounter(
    input clk,
    output reg[23:0] my_counter = 0
    );

    always @ (posedge clk)
    
    begin
        if (my_counter == 'h1FFFFF)
            begin
                my_counter = 0;
            end
        
        else 
            begin 
                my_counter <= my_counter + 1;
            end
    
    end 
    
endmodule
