`timescale 1ns / 1ps
module SPI_Master // Mode 0 -> CPOL=0,CPHA=0 -> data sampled on rising edge and shifted on falling edge, leading edge is the rising edge
 // default value is MODE=0
// MODE|CPOL | CPHA  | data sampled on ...edge  | data shifted out on ... edge
// 0   | 0   |	0    |		Rising		|	Falling
// 1   | 0   |	1    |		Falling		|	Rising
// 2   | 1   |	0    |		Falling		|	Rising
// 3   | 1   |	1    |		Rising		|	Falling
(
	input clk,reset,
	input reg[1:0]MODE,
//ports on the right-side
	input MISO,
	output reg MOSI,
	output CS1bar,
	output CS2bar,
	output CS3bar,
    	output wire sclk,// it's the internal clk for the module and sent to slaves 
	output wire sreset,//to be sent to the salve
	output wire[1:0]sMODE,//to be sent to the salve
//ports on the left-side
	input  reg [7:0]data_in, //for TB only
	output wire[7:0]data_out,//for TB only
	input  reg [1:0]CS,//has 4-states: 3 for the slaves and an idle state 
	input      [1:0]RW //Read-Write, //for TB only
// RW | read from MISO  | write on MOSI
// 00 | false		| flase
// 01 | false		| true
// 10 | true		| false
// 11 | true		| true
);
///
//wire sclk; // it's the internal clk for the module
///
//reg start_reading=0;
reg start_writting=0;
//RX
//reg [2:0]RX_bit_count; // counts the number of bits recieved before completing the byte
integer RX_bit_count=0;
reg [7:0]RX_temp_byte; // a temp register fot the recieved byte
reg [7:0]RX_byte; // the recieved byte 
reg RX_done=0;  // a flag that indicates that the byte is recieved correctly and check for the next one
//TX
reg [2:0]TX_bit_count; // counts the number of bits sent before finishing the byte
reg [7:0]TX_temp_byte; // a temp register fot the sent byte
//reg [7:0]Tx_byte; // the byte to be sent 
reg TX_done=0; // a flag that indicates that the byte is sent correctly and check for the next one
///
/////////////////////////////////////
assign sclk= (MODE==0||MODE==3)?clk:~clk; // assigning the internal clk to the universal clk !
assign sreset=reset;
assign sMODE=MODE;

assign CS1bar=(CS==2'b01)?0:1; // when CS is 1 then CS1bar is low which means is active
assign CS2bar=(CS==2'b10)?0:1; // when CS is 2 then CS2bar is low which means is active
assign CS3bar=(CS==2'b11)?0:1; // when CS is 3 then CS3bar is low which means is active

assign data_out=RX_done?RX_byte:8'bz;// if the byte is not done yet then the data out is z (high impedence)
/////////////////////////////////////
///
/////////////////////////////////////for MISO i.e. reading configuration /////////////////////////////////////
always @(posedge sclk,posedge reset)// in this mode of operation data is sampled with the positive edge of the clock
begin
//start_reading=1;

	//assign RX_byte=RX_done?RX_temp_byte:8'bx;
	if (reset==1)
	begin
		RX_bit_count<=0;
		RX_temp_byte<=0;
		RX_done<=0;
	end // if (reset==1)
	else if (CS&&(RW==2'b10||RW==2'b11)) //if the Master starts the communication with a slave and the reading from MISO is enabled
	begin
		if(RX_bit_count>=8&&RX_done==1'b0) 
		begin
		if (MISO!==1'bx)
		begin
			RX_done<=1'b1;
			RX_byte<=RX_temp_byte;

			RX_temp_byte <= {7'b0000000,MISO};
			RX_bit_count <= 1;

		end
		end

		else
		begin
		if (MISO!==1'bx)
		begin
			RX_done<=0;
			RX_temp_byte <= {RX_temp_byte[6:0],MISO};
			RX_bit_count <= RX_bit_count+1;
		end
		end //if (!RX_bit_count==3'b111)
	end //if !(CS&&(RW==2'b10||RW==2'b11))

end //@always (posedge sclk,posedge reset)
/////////////////////////////////////for MOSI i.e. writting configuration /////////////////////////////////////
// id data_in was samoled at time=0, the last bit will be shifted out from MISO at time=70 !
always @(posedge sclk,posedge reset)
begin
start_writting=1;
	if (reset==1)
	begin
		TX_temp_byte<=data_in;
		TX_done<=0;
		TX_bit_count<=3'b000;
	end //if (reset==1)
	else if (TX_done==1)
	begin
		TX_temp_byte<=data_in;
		TX_done<=0;
		TX_bit_count<=3'b000;
	end // if (TX_done==1)

end // @always (posedge sclk,posedge reset)
always @ (negedge sclk)
begin
if (start_writting)
begin
	if (CS&&(RW==2'b01||RW==2'b11)) // writting on MOSI is enabled
	begin
		if (TX_bit_count==3'b111&&TX_done==0)
		begin
			MOSI<=TX_temp_byte[0];//LSB : [data_in ->(MSB) TX_temp_byte (LSB)-> MOSI]
			TX_done<=1;
		end
		else // if !(TX_bit_count==3'b111&&TX_done==0)
		begin
			MOSI<=TX_temp_byte[0];//LSB : [data_in ->(MSB) TX_temp_byte (LSB)-> MOSI]
			TX_temp_byte={1'b0,TX_temp_byte[7:1]};
			TX_bit_count<=(TX_bit_count+1);
			TX_done<=0;
		end
		
	end //if (CS==0)
	else //if !(CS==0)
	begin
		MOSI<=1'bx;
	end
end
end //always @ (negedge sclk)
endmodule


