`timescale 1 ns / 10 ps
module SPI_TB();
reg[1:0] MODE;
reg reset;
reg sclk; 
reg [1:0] CS;
reg [1:0] RW;
reg [7:0] data_in_to_master;
wire [7:0] data_out_from_master;

reg [7:0] data_in_slave1;
reg [7:0] data_in_slave2;
reg [7:0] data_in_slave3;

wire [7:0] data_out_slave1;
wire [7:0] data_out_slave2;
wire [7:0] data_out_slave3;

localparam period=10;
//***************
reg [7:0] test_case[3:0];
reg [7:0]expected_output[3:0];
reg[3:0]passed_testcases=0;
reg[3:0]temp_passed_testcases;
//**************************
Spi_Protocol SPI(.clk(sclk), .reset(reset),
.data_in_to_master(data_in_to_master), .data_out_from_master(data_out_from_master),
.data_in_slave1(data_in_slave1), .data_in_slave2(data_in_slave2), .data_in_slave3(data_in_slave3),
.data_out_slave1(data_out_slave1), .data_out_slave2(data_out_slave2), .data_out_slave3(data_out_slave3),
.CS(CS), .RW(RW), .MODE(MODE));

always #(period/2) sclk = ~sclk;
//****************************TestCase1******************************
task testcase1(input [7:0]input_vector,input [7:0] expected_vector,input [7:0]input_vector1,input [7:0] expected_vector1);
	begin
        $display("############## TestCase (1)----> Mode 1 ############");
	$display("Hey Master , Send your data to SLave #1 and recieve data from it");
	reset=1'b1;
        sclk=1'b0; 
        MODE=2'b01;
        data_in_to_master=input_vector;
        data_in_slave1=input_vector1;
	$display("\n Current data in Master =%b",data_in_to_master);
        $display("\n Current data in Slave =%b",data_in_slave1);
	$display("\n expected data output from Master =%b",expected_vector1);
        $display("\n expected data output from slave =%b",expected_vector);
	//

        #period reset=1'b0;
        #period
        CS=2'b01;
        RW=2'b11;

        #(10*period);  
        CS=2'b00;
 
        $display("\n #time=%g,\n exact output data from master=%b,\n exact output data from slave =%b",$time,
        data_out_from_master,data_out_slave1);

	if ((data_out_from_master==expected_vector1)&&(data_out_slave1==expected_vector))
	begin
	$display("\n testcase #1 is passed successfuly");
        $display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	passed_testcases=passed_testcases+1;
	end
end
endtask
//******************************TC 2****************************
task testcase2(input [7:0]input_vector,input [7:0] expected_vector,input [7:0]input_vector1,input [7:0] expected_vector1);
	begin
        $display("############## TestCase (2)----> Mode 2 ############");
	$display("Hey Master , Send your data to SLave #2 and recieve data from it ");
        #period
        sclk=1;
        reset=1'b1;
        MODE=2'b10;
        data_in_to_master=input_vector;
        data_in_slave2=input_vector1;
	$display("\n Current data in Master =%b",data_in_to_master);
        $display("\n Current data in Slave 2 =%b",data_in_slave2);
	$display("\n expected data output from Master =%b",expected_vector1);
        $display("\n expected data output from slave =%b",expected_vector);
	//

        #period reset=1'b0;
        #period
        CS=2'b10;
        RW=2'b11;

        #(10*period);
        CS=2'b00;

        $display("\n #time=%g,\n exact output data from master=%b,\n exact output data from slave =%b",$time,
        data_out_from_master,data_out_slave2);

	if ((data_out_from_master==expected_vector1)&&(data_out_slave2==expected_vector))
	begin
	$display("\n testcase #2 is passed successfuly");
        $display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	passed_testcases=passed_testcases+1;
	end
end
endtask
//****************************************************************************
task testcase3(input [7:0]input_vector,input [7:0] expected_vector,input [7:0]input_vector1,input [7:0] expected_vector1,input [7:0]input_vector2,input [7:0] expected_vector2);
	begin
	temp_passed_testcases=0;
        $display("############## TestCase (3)----> Mode 0 ############");
	$display("Hey Master , Read data from SLave #3 and send data to it");
 	$display("and send it to Slave #2 and read from slave #2");
        #period
        sclk=0;
        reset=1'b1;
        MODE=2'b00;
        data_in_to_master=input_vector;
        data_in_slave2=input_vector1;
        data_in_slave3=input_vector2;
	$display("\n Current data in Master =%b",data_in_to_master);
        $display("\n Current data in Slave #3 =%b",data_in_slave3);
	$display("\n expected data output from Master =%b",expected_vector2);
        $display("\n expected data output from slave #3 =%b",expected_vector);
	//

        #period reset=1'b0;
        //#period
        CS=2'b11;
        RW=2'b11;

        #(10*period); CS=2'b00;
        $display("\n #time=%g,\n exact output data from master=%b,\n exact output data from slave#3 =%b",$time,
        data_out_from_master,data_out_slave3);

	if ((data_out_from_master==expected_vector2)&&(data_out_slave3==expected_vector))
	begin
	$display("sub testcase #1 is passed successfuly");
	temp_passed_testcases=temp_passed_testcases+1;
	end
	#period reset=1'b1; 
        data_in_to_master=data_out_from_master;
	$display("\n Current data in Master =%b",data_in_to_master);
        $display("\n Current data in Slave #2 =%b",data_in_slave2);
	$display("\n expected data output from Master =%b",expected_vector1);
        $display("\n expected data output from slave #2 =%b",expected_vector2);
	////
        //$display("clock after sub testcase3 =%b",sclk);
        #period reset=1'b0; 
        #(period/2)
        CS=2'b10;
        //RW=2'b11;

        #(9*period);CS=2'b00;
        $display("\n #time=%g,\n exact output data from master=%b,\n exact output data from slave =%b",$time,
        data_out_from_master,data_out_slave2);
	if ((data_out_from_master==expected_vector1)&&(data_out_slave2==expected_vector2))
	begin
	$display("sub testcase #2 is passed successfuly");
	temp_passed_testcases=temp_passed_testcases+1;
	end
	if (temp_passed_testcases>=2)
	begin
	$display("testcase #3 is passed successfuly");
	$display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	passed_testcases=passed_testcases+1;
	end
end
endtask
//*****************************************************************
task testcase4(input [7:0]input_vector,input [7:0] expected_vector,input [7:0]input_vector1,input [7:0] expected_vector1,input [7:0]input_vector2,input [7:0] expected_vector2,input [7:0]input_vector3,input [7:0] expected_vector3);
	begin
	temp_passed_testcases=0;
        $display("############## TestCase (4)----> Mode 3 ############");
	$display("Hey Master , send and Read data from SLave #1");
 	$display("send the data you read to Slave #2 and Read data from Slave#2");
	$display("send the data you read to slave #3 and Read data from Slave#3");
        #period
        sclk=1;
        reset=1'b1;
        MODE=2'b11;
        data_in_to_master=input_vector;
        data_in_slave1=input_vector1;
        data_in_slave2=input_vector2;
        data_in_slave3=input_vector3;
	$display("\n Current data in Master =%b",data_in_to_master);
        $display("\n Current data in Slave #1 =%b",data_in_slave1);
	$display("\n expected data output from Master =%b",expected_vector1);
        $display("\n expected data output from slave #1 =%b",expected_vector);
	//

        #period reset=1'b0;
        //#period
        CS=2'b01;
        RW=2'b11;

        #(9*period); CS=2'b00;
        $display("\n #time=%g,\n exact output data from master=%b,\n exact output data from slave#1 =%b",$time,
        data_out_from_master,data_out_slave1);

	if ((data_out_from_master==expected_vector1)&&(data_out_slave1==expected_vector))
	begin
	$display("\n sub testcase #1 is passed successfuly");
	temp_passed_testcases=temp_passed_testcases+1;
	end
	#period reset=1'b1; 
        data_in_to_master=data_out_from_master;
	$display("\n Current data in Master =%b",data_in_to_master);
        $display("\n Current data in Slave #2 =%b",data_in_slave2);
	$display("\n expected data output from Master =%b",expected_vector2);
        $display("\n expected data output from slave #2 =%b",expected_vector1);
	//

        #period reset=1'b0; 
        //#(period/2)
        CS=2'b10;
        RW=2'b11;

        #(9*period);CS=2'b00;
        $display("\n #time=%g,\n exact output data from master=%b,\n exact output data from slave =%b",$time,
        data_out_from_master,data_out_slave2);
	if ((data_out_from_master==expected_vector2)&&(data_out_slave2==expected_vector1))
	begin
	$display("\n sub testcase #2 is passed successfuly");
	temp_passed_testcases=temp_passed_testcases+1;
	end
        #period reset=1'b1; 
        data_in_to_master=data_out_from_master;
	$display("\n Current data in Master =%b",data_in_to_master);
        $display("\n Current data in Slave #3 =%b",data_in_slave3);
	$display("\n expected data output from Master =%b",expected_vector3);
        $display("\n expected data output from slave #3 =%b",expected_vector2);
	//

        #period reset=1'b0; 
        CS=2'b11;
        RW=2'b11;

        #(9*period);CS=0; 
        $display("\n #time=%g,\n exact output data from master=%b,\n exact output data from slave =%b",$time,
        data_out_from_master,data_out_slave3);


	if ((data_out_from_master==expected_vector3)&&(data_out_slave3==expected_vector2))
	begin
	$display("\nsub testcase #3 is passed successfuly");
	temp_passed_testcases=temp_passed_testcases+1;
	end
	if (temp_passed_testcases>=3)
	begin
	$display("testcase #4 is passed successfuly");
	$display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	passed_testcases=passed_testcases+1;
	end
end
endtask
//*******************************************************************
//***************TestCases1,2,3,4*************************
task testcases1234(input [7:0]input_vector0,input [7:0] expected_vector0,
		   input [7:0]input_vector1,input [7:0] expected_vector1,
		   input [7:0]input_vector2,input [7:0] expected_vector2,
		   input [7:0]input_vector3,input [7:0] expected_vector3);
begin
	passed_testcases=0;
	//sending one byte to slave #1 and reciving another byte from it,MODE #1
	testcase1(input_vector3,expected_vector3,input_vector2,expected_vector2);
	//sending one byte to slave #2 and reciving another byte from it,MODE #0
	testcase2(input_vector1,expected_vector1,input_vector3,expected_vector3);
	//sending and reading from slave #3 and sending the readigs to slave #2 and read another one,mode#0
	testcase3(input_vector2,expected_vector2,input_vector1,expected_vector1,
		  input_vector0,expected_vector0);
	// Read data from SLave #1 and send it to Slave #2 then Read data from Slave#2 send it to slave #3, mode #3
	testcase4(input_vector0,expected_vector0,input_vector1,expected_vector1,input_vector2,expected_vector2,input_vector3,expected_vector3);

	$display("\n\n %d out of 4 testcases passed successfuly\n",passed_testcases);
	passed_testcases=0;

end
endtask
initial begin

test_case[3]=8'b10101010;
test_case[2]=8'b11100111;
test_case[1]=8'b11001100;
test_case[0]=8'b10010001;

expected_output[3]=8'b10101010;
expected_output[2]=8'b11100111;
expected_output[1]=8'b11001100;
expected_output[0]=8'b10010001;
///

testcases1234(test_case[0],expected_output[0],
	      test_case[1],expected_output[1],
	      test_case[2],expected_output[2],
	      test_case[3],expected_output[3]);
///


$stop;

end
endmodule
