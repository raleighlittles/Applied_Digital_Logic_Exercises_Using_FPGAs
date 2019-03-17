`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2019 03:18:44 PM
// Design Name: 
// Module Name: SimplePWM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This is the module you have to create for Step 4 of the "Detailed Description" in section 4.6.2.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SimplePWM(
   input clk_in,
   input [7:0] x_in,
   output reg pwm_out
    );
    reg [7:0] counter = 0;
    
   always @ (posedge clk_in)
   begin
        if (counter < x_in)
            begin 
            pwm_out <= 1;
        end
        
        else 
            begin
                pwm_out <= 0;
            end
    end
   
endmodule
