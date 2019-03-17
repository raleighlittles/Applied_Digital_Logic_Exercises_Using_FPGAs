`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Minnesota	
// Engineer: Kurt Wick
// 
// Create Date:    14:06:21 07/22/2008 
// Design Name: 
// Module Name:    FlashMemModules3 
// Project Name: 
// Target Devices: Digilent Inc PmodSF wit St Microelectronics M25P16, 16Mbit Serial Flash ROM 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Copyright Regents University of Minnesota March  18, 2009
//
//////////////////////////////////////////////////////////////////////////////////

// updated to use ReadOneByteV3 (also removed port busy)
//Read 2 Bytes of Data Back from flash memory  TESTED WORKS 9-12-08 KW
//formerly known as:
//module Inst_READ_TwoBytes(clk_in, enable, address, Q, NCS, D, clk_out, busy, data);
module ReadTwoBytesV3(clk_in, enable, address, Q, NCS, D, clk_out, data);
	parameter NEWMAXBYTES = 2;

    input clk_in;
    input enable;
	 input [23:0] address; 
	 input Q;
    output NCS;
    output D;
    output clk_out;
    	 
	 output [8*NEWMAXBYTES-1:0] data;

    wire busy;	

defparam
	XReadOneFlashByte.MAXBYTES = NEWMAXBYTES;

//ReadOneByte XReadOneFlashByte(clk_in, enable, address, Q, NCS, D, clk_out, busy, data); //old version
ReadOneByteV3 XReadOneFlashByte(clk_in, enable, address, Q, NCS, D, clk_out, data);
endmodule



//Read Data Back from flash memory  TESTED WORKS 7-24-08 KW
//updated to slow down main clock by factor of 4 for 100 MHz BASYS3 boards
// removed busy port since it doesn't do any thing kw 10-14-16  
//updated to buffer output (data_in) till it is ready and then assign it to "data" kw 9-12-08
//formerly known as:ReadOneByte
//module Inst_READ_One_Buffered_Byte(clk_in, enable, address, Q, NCS, D, clk_out, busy, data);
module ReadOneByteV3(clk, enable, address, Q, NCS, D, clk_out, data);
    input clk;  //sys clock that times read / write instructions
    input enable;  //trigger - on positive edge enabled
	input [23:0] address; //starting read address
	input Q;		//Q line to Flash Memory - reads data from memory
    output NCS;	//Not Chip Select line for Flash Memory
    output D;		//D line to Flash Memory - sends data to memory
    output clk_out;	//clk line to Memory

	 output data;	//data read from memory

	parameter MAXBYTES = 1; //maximum bytes read can be infinite as entire memory can be read
	parameter INST_READ = 8'h03;	 
	parameter BITS_INST = 8;
	parameter BITS_ADDR = 24;
	parameter BITS_DATA = 8*MAXBYTES; //maximum bytes to be written per page 256

	reg [BITS_INST+BITS_ADDR-1:0] instr; // 
	reg [5:0] bcounter = BITS_INST+BITS_ADDR-1;
	
	reg [BITS_DATA-1:0] datain; //temp buffer to assemble data
	reg [BITS_DATA-1:0] data; //final buffer once byte is assembled
	reg [10:0] readcounter = BITS_DATA;	
	
	reg Dint = 1'bx;
	reg NCSint = 1;	

    wire busy;	//positive while reading; neg edge when done reading one byte; was port not needed
	
    //slow down system clock for BASYS3 100 MHz sys clock		
	wire clk_in;
	parameter SLOWDOWN_BITS = 3;  //slow clock down by 2^SLOWDOWN_BITS; use 2 for BASYS3 100 MHz (added on extra bit for safety)
	reg [SLOWDOWN_BITS-1:0] slow_clk = 0;	
	always @(posedge clk)
		slow_clk <= slow_clk + 1;
	
	assign clk_in = slow_clk[SLOWDOWN_BITS-1];

	reg clk_in2=0;  //clock divider
	always @(posedge clk_in)
		clk_in2 <= ~clk_in2;

	
	
	//enable latch
	reg enable_latch_set = 0;
	reg enable_latch_reset = 0;
	always@(posedge enable or posedge enable_latch_reset)
		if( enable_latch_reset)
			enable_latch_set = 0;
		else
			enable_latch_set = 1;
	
	
   parameter ST_IDLE = 2'b00;
   parameter ST_READ = 2'b01;
   parameter ST_SEND = 2'b10;
   parameter ST_DONE = 2'b11;

   (* FSM_ENCODING="SEQUENTIAL", SAFE_IMPLEMENTATION="NO" *)
	reg [1:0] state = ST_IDLE;

   always@(	posedge clk_in)
      
         (* FULL_CASE, PARALLEL_CASE *) case (state)
            ST_IDLE : begin
               if (enable_latch_set & clk_in2) begin
                  state <= ST_SEND;				
						end
               else begin
                  state <= ST_IDLE;
						end
				NCSint <= 1'b1;
            bcounter <= BITS_INST+BITS_ADDR-1;
				readcounter <= BITS_DATA;	
				instr <= {INST_READ, address  };
				end

				ST_SEND : begin
               if( clk_in2) //wants pos clock edge only
						state <= ST_SEND;
					else if (bcounter) begin               
                  state <= ST_SEND;
						Dint <= instr[bcounter];
						bcounter <= bcounter -1;
						end
               else begin
                  state <= ST_READ;
						Dint <= instr[bcounter];
						bcounter <= bcounter -1;
						end
               
					NCSint <= 1'b0;
					enable_latch_reset <= 1'b1; //reset the enable_latch; avoid retriggering
            end


				ST_READ : begin
				   if( ~clk_in2) //wants neg edge only
						state <= ST_READ;
					else if (readcounter) begin               
                  state <= ST_READ;
						//DataRead <= {DataRead[MAXBITS-2:0], Q };
						datain <= {datain[BITS_DATA-2:0], Q};
						readcounter <= readcounter -1;
						end
               else begin
                  state <= ST_DONE;
						//DataRead <= {DataRead[MAXBITS-2:0], Q };						
						datain <= {datain[BITS_DATA-2:0], Q};
						readcounter <= readcounter -1;
						end
               
					NCSint <= 1'b0;
            end

            
				ST_DONE : begin
					if( ~clk_in2)
						state <= ST_DONE;
					else begin
						state <= ST_IDLE;
						NCSint <= 1'b1;
						enable_latch_reset <= 1'b0; //reset the enable_latch; allow retriggering
						data <= datain;
					end
				
            end				
				
         endcase
		
		assign clk_out = ~NCSint? ~clk_in2 : 1'bz;
		assign D = ~NCSint? Dint : 1'bz;
		assign NCS =  NCSint;
		assign busy =~NCSint | enable_latch_set;
		assign Qout = ~NCSint ? Q : 1'bz;
		
	
endmodule