`timescale 1ns / 1ps
module MasterTB();
//interanl containers
reg[1:0] MODE=0;
integer i;
reg[3:0]passed_testcases;
reg[3:0]temp_passed_testcases;
//internal signals
reg clk;
reg reset;
reg [7:0]data_in_to_master;
wire[7:0]data_out_from_master;
reg [1:0]CS;
reg [1:0]RW;
wire MOSI;
wire MISO;
wire sclk;
wire sreset;
wire[1:0]sMODE;
wire CS1bar,CS2bar,CS3bar;
//clock period
localparam PERIOD =10;
/////////////////////////////////////
//clock
always
#(PERIOD/2) clk=~clk;
//internal modules
SPI_Master  MSTR
(
 .clk(clk),
 .reset(reset),

 .MODE(MODE),
 .MISO(MISO),
 .MOSI(MOSI),

 .sclk(sclk),
 .sreset(sreset),
 .sMODE(sMODE),

 .CS(CS),
 .RW(RW),

 .data_in(data_in_to_master),
 .data_out(data_out_from_master),

 .CS1bar(CS1bar),
 .CS2bar(CS2bar),
 .CS3bar(CS3bar)
);
/////////////////////////////////////
//in this TB data will go as follows :
// data_in_to_master -> MOSI -> MISO -> data_out_from_master
// by this way we can test reading and writting in the same time
// it's obvoius that by this way data will be reversed !
reg [7:0]test_case[3:0];
reg [7:0]expected_output[3:0];
assign MISO=MOSI; // for testing the Master only , the data getting out from MOSI will enter the MISO
//tasks
//***************TestCase1*************************
task testcase1(input [7:0]input_vector,input [7:0] expected_vector);
begin
	$display("\n############## TestCase (1)----> Mode 0 ############");
	$display("Hey Master, send this data to salve #1 and read its reverse");
	MODE=2'b00;
	clk=(MODE==2||MODE==3)?1:0;
	data_in_to_master=input_vector;
	$display("data_in=%b",data_in_to_master);
	$display("expected output=%b",expected_vector);
	//
	reset=1'b1;
	#PERIOD reset=1'b0; 
	#PERIOD RW=2'b11; CS=2'b01;
	//
	for (i=0;i<10;i=i+1)
	begin
	#PERIOD;
	if (data_out_from_master==expected_vector)
	begin
	$display ("$time=%g,clk=%b,data_out=%b", $time,clk,data_out_from_master);
	$display("testcase #1 is passed successfuly");
	$display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	passed_testcases=passed_testcases+1;
	end
	end
end
endtask

//***************TestCase2*************************
task testcase2(input [7:0]input_vector1,input [7:0]input_vector2,input [7:0] expected_vector1,input [7:0] expected_vector2);
begin
	temp_passed_testcases=0;
	$display("\n############## TestCase (2)----> Mode 1 ############");
	$display("Hey Master, send this 2-bytes to salve #2 and read there reverse");
	
	MODE=2'b01;
	clk=(MODE==2||MODE==3)?1:0;
	data_in_to_master=input_vector1;
	$display("data_in=%b",data_in_to_master);
	$display("expected output=%b",expected_vector1);
	//
	reset=1'b1;
	#PERIOD reset=1'b0; 
	#PERIOD RW=2'b11; CS=2'b10;
	//
	data_in_to_master=input_vector2;
	for (i=0;i<10;i=i+1)
	begin
	#PERIOD;
	if (data_out_from_master==expected_vector1)
	begin
	$display ("$time=%g,clk=%b,data_out=%b", $time,clk,data_out_from_master);
	$display("sub testcase #1 is passed successfuly");
	temp_passed_testcases=temp_passed_testcases+1;
	end
	end
	$display("data_in=%b",data_in_to_master);
	$display("expected output=%b",expected_vector2);
	for (i=0;i<10;i=i+1)
	begin
	#PERIOD;
	if (data_out_from_master==expected_vector2)
	begin
	$display ("$time=%g,data_out=%b", $time,data_out_from_master);
	$display("sub testcase #2 is passed successfuly");
	temp_passed_testcases=temp_passed_testcases+1;
	end
	end
	if (temp_passed_testcases>=2)
	begin
	$display("testcase #2 is passed successfuly");
	$display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	passed_testcases=passed_testcases+1;
	end
end
endtask

//***************TestCase3*************************
task testcase3(input [7:0]input_vector,input [7:0] expected_vector);
	begin
	$display("\n############## TestCase (3)----> Mode 2 ############");
	$display("Hey Master, send this data to salve #3 and read its reverse");
	
	MODE=2'b10;
	clk=(MODE==2||MODE==3)?1:0;
	data_in_to_master=input_vector;
	$display("data_in=%b",data_in_to_master);
	$display("expected output=%b",expected_vector);
	//
	reset=1'b1;
	#PERIOD reset=1'b0; 
	#PERIOD RW=2'b11; CS=2'b11;
	//
	for (i=0;i<10;i=i+1)
	begin
	#PERIOD;
	if (data_out_from_master==expected_vector)
	begin
	$display ("$time=%g,clk=%b,data_out=%b", $time,clk,data_out_from_master);
	$display("testcase #3 is passed successfuly");
	$display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	
	passed_testcases=passed_testcases+1;
	end
	end
end
endtask

//***************TestCase4*************************
task testcase4(input [7:0]input_vector);
begin
	temp_passed_testcases=0;
	$display("\n############## TestCase (4)----> Mode 3 ############");
	$display("Hey Master, send this data to salve #3  showing the details of sending and read nothing");
	 
	MODE=2'b11;
	clk=(MODE==2||MODE==3)?1:0;
	data_in_to_master=input_vector;
	$display("data_in=%b",data_in_to_master);
	$display("expected output= NO output expected i.e (z)");
	//
	reset=1'b1;
	#PERIOD reset=1'b0; 
	RW=2'b01; CS=2'b11;
	//
	for (i=0;i<8;i=i+1)
	begin
	#PERIOD $display("MOSI=%b",MOSI);
	if (MOSI==data_in_to_master[i])
	begin
	$display("passed");
	temp_passed_testcases=temp_passed_testcases+1;
	end
	end
	if (temp_passed_testcases>=8)
	begin
	$display ("$time=%g,clk=%b,data_out=%b", $time,clk,data_out_from_master);
	$display("testcase #4 is passed successfuly");
	$display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	
	passed_testcases=passed_testcases+1;
	end
end
endtask
//***************TestCases1,2,3,4*************************
task testcases1234(input [7:0]input_vector0,input [7:0] expected_vector0,
		   input [7:0]input_vector1,input [7:0] expected_vector1,
		   input [7:0]input_vector2,input [7:0] expected_vector2,
		   input [7:0]input_vector3,input [7:0] expected_vector3);
begin
	passed_testcases=0;
	//send one byte to salve #3 and read it again, mode0
	testcase1(input_vector3,expected_vector3);
	//send two bytes to salve #2 and read them again, mode1
	testcase2(input_vector2,input_vector1,expected_vector2,expected_vector1);
	//send one byte to salve #1 and read it again, mode2
	testcase3(input_vector0,expected_vector0);
	//send one byte to salve #3 and show the details os sending the data, mode3
	testcase4(input_vector3);
	$display("\n\n%d out of 4 testcases passed successfuly\n",passed_testcases);
	passed_testcases=0;

end
endtask
/////////////////////////////////////
initial begin 
///

test_case[3]=8'b10101010;
test_case[2]=8'b11100111;
test_case[1]=8'b11001100;
test_case[0]=8'b10010001;

expected_output[3]=8'b01010101;
expected_output[2]=8'b11100111;
expected_output[1]=8'b00110011;
expected_output[0]=8'b10001001;
///
testcases1234(test_case[0],expected_output[0],
	      test_case[1],expected_output[1],
	      test_case[2],expected_output[2],
	      test_case[3],expected_output[3]);
///
$stop;
end
endmodule

