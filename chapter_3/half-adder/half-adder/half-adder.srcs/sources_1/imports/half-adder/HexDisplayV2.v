`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kurt Wick
// Downloaded from: https://sites.google.com/a/umn.edu/mxp-fpga/home/vivado-notes/phys4051-course-related-materials
// Create Date:    16:35:40 07/30/2009 
// Design Name: 
// Module Name:    HexDisplayV1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Converts a binary value (if desired) into a BCD and displays it on the four
//		7 segement HEX displays.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:  READ COMMENTS DIRECTLY BELOW REGARDING PIN ASSIGNMENTS!
//
//////////////////////////////////////////////////////////////////////////////////

//PLEASE R E A D !!!!!!!!!!!!!! IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// BASYS3 Version
///////////////////////////////////////////////////////////////////////////////////////////////


module HexDisplayV2(
	input clk,				 //the system clock running at least 25 MHz
	input [15:0] value_in,	 //the 16 bit binary value to be displayed
	input BCD_enable,	     //if HI converts binary value into decimal value, else displays HEX
	input Display_Enable,    //if HI display is enabled, LO turns it off.	
	output [6:0] seg,	     //each bit corresponds to one of the 7 segments on the display
	output [3:0] an	         //specifies which of the 4 displays is to be turned on (temporarily)
    );

	/**********************************************************************************/	
	//divide the systme clock signal down to a few Hz and use it to multiplex and turn on/off 
	//each hex display
	parameter CLKBIT = 16;  //clk divider speed
	reg [CLKBIT:0] clk_div = 0;
	always @(posedge clk) begin
		clk_div <= clk_div + 1;	
	end 
		
	wire [1:0] digit_select; //
	assign digit_select = clk_div[CLKBIT:CLKBIT-1]; //use two MSB to select digits
	
	wire [15:0] BCD_out;
	Hex2BCD MyHex2BCD(clk, value_in, BCD_out, busy);
		
	wire[15:0] value_used;
	assign value_used = BCD_enable ? BCD_out : value_in;
	
	//now multiplex, i.e., send alternate 4 bits of the input value to the display
	wire [3:0] tmp_value;	
	assign tmp_value = (digit_select ==  2'b00 ) ? value_used[3:0]:
							 (digit_select ==  2'b01 ) ? value_used[7:4]:
							 (digit_select ==  2'b10 ) ? value_used[11:8]:
							 (digit_select ==  2'b11 ) ? value_used[15:12]:
							 4'b1111;

	EnableDigit MyEnableDigit( digit_select, an );
	DisplayDigit MyDisplayDigit( tmp_value, Display_Enable, seg );	
		
endmodule




//Module takes a 4 bit binary input value and displays it in the four 7-segment displays.
// kw 10/4/07
//
// Arguments:
// 	Input: "valueIn" the 4 bit binary value to be displayed.
//		Output: "sevenSegOut" the corresponding 7-segment encoding of "valueIn"  (see below).
//      0
//     ---
//  5 |   | 1
//     --- <--6
//  4 |   | 2
//     ---
//      3
// Display Pin Outs:
//		The pins for the 7 bit "sevenSegOut" must be assigned with a "synthesis attribute" statement and they correspond
//		to pins: "P83 P17 P20 P21 P23 P16 P25" 
//
//  Note: to turn on only one of the four 7 segment displays either set its corresponding anode pin low while leaving
//		all the others high or use module "EnableDigit" below.


module DisplayDigit( valueIn, Display_Enable, sevenSegOut);
	input [3:0] valueIn;	//4 bit input value
	input Display_Enable; //if HI display is enabled, else all segments are off
	output [6:0] sevenSegOut; //seven segment settings: sets each of the 7 segments to on or off

	assign sevenSegOut =  ((valueIn == 4'b0000)& Display_Enable) ? 7'b1000000:   // 1
								 ((valueIn == 4'b0001)& Display_Enable) ? 7'b1111001:   // 1
								 ((valueIn == 4'b0010)& Display_Enable) ? 7'b0100100:   // 2
								 ((valueIn == 4'b0011)& Display_Enable) ? 7'b0110000:   // 3
								 ((valueIn == 4'b0100)& Display_Enable) ? 7'b0011001:   // 4
								 ((valueIn == 4'b0101)& Display_Enable) ? 7'b0010010:   // 5
								 ((valueIn == 4'b0110)& Display_Enable) ? 7'b0000010:   // 6
								 ((valueIn == 4'b0111)& Display_Enable) ? 7'b1111000:   // 7
								 ((valueIn == 4'b1000)& Display_Enable) ? 7'b0000000:   // 8
								 ((valueIn == 4'b1001)& Display_Enable) ? 7'b0010000:   // 9
								 ((valueIn == 4'b1010)& Display_Enable) ? 7'b0001000:   // A
								 ((valueIn == 4'b1011)& Display_Enable) ? 7'b0000011:   // b
								 ((valueIn == 4'b1100)& Display_Enable) ? 7'b1000110:   // C
								 ((valueIn == 4'b1101)& Display_Enable) ? 7'b0100001:   // d
								 ((valueIn == 4'b1110)& Display_Enable) ? 7'b0000110:   // E
								 ((valueIn == 4'b1111)& Display_Enable) ? 7'b0001110:   // F
								 7'b1111111;   // default i.e. all segments off!
								 

endmodule


//Module takes a 2 bit binary input value and enables one of the four 7-segment displays.
// kw 10/4/07
//
// Arguments:
//		Input: "digitSelectIn" a 2 bit value which enables one of the four display digits, with 0 
//				corresponding to the rightmost one, and 3 to the leftmost.
//		Output: "digSelectOut" the 4 bit value corresponding to "digitSelectIn" that turns only
//				one of the 4 displays on by setting its corresponding anode pin low.
//
// Display Pin Outs:
//		The pins to turn a digit on or off must be assigned with a "synthesis attribute" statement and they correspond
// 	to pins: "P26  P32 P33 P34"


module EnableDigit( digitSelectIn, digSelectOut);
	input [1:0] digitSelectIn; //0 is right most digit, 1 is 2nd rightmost etc, 3 is leftmost
	output [3:0] digSelectOut; //digit selections to turn individual digit (anodes) on or off	
	assign digSelectOut = (digitSelectIn == 2'b00) ? 4'b1110:   // right most digit
								 (digitSelectIn == 2'b01) ? 4'b1101:   // 2nd right most digit
								 (digitSelectIn == 2'b10) ? 4'b1011:   // 3rd right most digit
								 (digitSelectIn == 2'b11) ? 4'b0111:   // left most digit
								 4'b0000;   //DEFAULT: enable all digits
      
			
endmodule




//////////////////////////////////////////////////////////////////////////////////
module Hex2BCD(sys_clk, HexIn, BCD_out, busy);
    //works tested kw 8/1/08
	 // converts a POSITVE or UNSIGNED binary value into a 4 digit BCD
	 //signal valid at negative going edge of busy
	 //based on Jermiah's Mans Code
	 input [15:0] HexIn;    //check that it does not exceed max value
    input sys_clk;

    output reg [15:0] BCD_out = 0;
	 output reg busy = 0;
	

	//BCD conversion is based on shift-register technique with carry depending on whether value>=5

	reg [3:0] digit0, digit1, digit2, digit3;
	wire carry0, carry1, carry2;
	reg [4:0] counter =0;
		
	assign carry0=(digit0>4);
	assign carry1=(digit1>4);
	assign carry2=(digit2>4);

	always @(posedge sys_clk) begin
		if (counter==0) begin
			digit0<=0;
			digit1<=0;
			digit2<=0;
			digit3<=0;
			busy <= 1'b1;
			counter <= counter + 1;
		end
		
		else if (counter<17) begin
		  if (carry0)
				digit0<={digit0-5,HexIn[16-counter]};
		  else
				digit0<={digit0[2:0],HexIn[16-counter]};
		
		  if (carry1)
				digit1<={digit1-5,carry0};
		  else
				digit1<={digit1[2:0],carry0};
	
		  if (carry2)
				digit2<={digit2-5,carry1};
		  else
				digit2<={digit2[2:0],carry1};
	
		  digit3<={digit3[2:0],carry2};
		  counter <= counter + 1;
		end 
		
		else if (counter == 17 ) begin
			if( HexIn < 10000 ) //check that the BCD input value is not exceeding 9999
				BCD_out <= {digit3,digit2,digit1,digit0}; //if so force output always to 9999
			else
				BCD_out <= 16'h9999; //maximum value to be displayed Maybe should be 0xFFFF?
			busy <= 1'b0;
				counter <= 0;
		end
	
	end

endmodule



