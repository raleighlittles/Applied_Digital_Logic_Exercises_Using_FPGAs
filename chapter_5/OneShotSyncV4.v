`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Minnesota
// Engineer: Kurt Wick
// 
// Create Date:    16:05:57 07/15/2013 
// Design Name: 
// Module Name:    RadCounterWCoincidenceV1a 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 10/20/16 Updated Comments
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module OneShotV4( 
	input clk,
	input asynctrigger_in,
	output reg pulse_out = 0
	);
	
	reg trig_set = 0;

    //asynchronous flip-flop		
	always@(posedge asynctrigger_in or posedge pulse_out)
		if( pulse_out)
			trig_set <= 0;
		else
			trig_set <=1;		

	always@( posedge clk)
		if( trig_set)
			pulse_out <= 1;
		else
			pulse_out <=0;
			
endmodule
