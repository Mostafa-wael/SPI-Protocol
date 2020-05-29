`timescale 1 ns / 10 ps
module Slave_TB();
reg[1:0] MODE;
reg reset;
reg sclk; 
reg MOSI;
wire MISO;
reg scbar;
reg [7:0] data_in;
reg [7:0] data_out_of_slave;
wire [7:0] slv_data;
localparam period=10;
//wire [7:0] current;
//***************
reg [7:0]test_case[3:0];
reg [7:0]expected_output[3:0];
reg[3:0]passed_testcases=0;
reg[3:0]temp_passed_testcases;
integer i;
//**************************
slave SLV_1(.MODE(MODE),.data_in(data_in),
.reset(reset),.clk(sclk),.MOSI(MOSI),.MISO(MISO),.CS(scbar),.data_out(slv_data));
always 
begin
#(period/2) sclk = ~sclk;
end

task testcase1(input [7:0]input_vector,input [7:0] expected_vector);
	begin
        assign MOSI=MISO;
        $display("############## TestCase (1)----> Mode 2 ############");
	$display("HEY Slave , what data did the Master send you?");
	MODE=2'b10;
	data_in=input_vector;
	$display("\n data in to Slave =%b",data_in);

	$display("\n expected data output from slave=%b",expected_vector);
	//
        sclk=1;
	reset=1'b1;
	#period reset=1'b0; 
	#period  scbar=0;
	//
	for (i=0;i<10;i=i+1)
	begin
	#period;
        end
	if (slv_data==expected_vector)
	begin
	$display ("\n $time=%g,clk=%b,data_out=%b", $time,sclk,slv_data);
	$display("\n testcase is passed successfuly");
        $display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//");
	passed_testcases=passed_testcases+1;
	end
end
endtask
//***************TestCase2*************************
task testcase2(input [7:0]input_vector1,input [7:0]input_vector2,input [7:0] expected_vector1,input [7:0] expected_vector2);
begin   assign MOSI=MISO;
	temp_passed_testcases=0;
        $display("############## TestCase (2)----> Mode 1 ############");
	$display("HEY Slave , what data did the Master send you?");
	MODE=2'b01;
	sclk=0;
	data_in=input_vector1;
	$display("\n data in to Slave =%b",data_in);
	$display("\n expected data output from slave=%b",expected_vector1);
	//
	reset=1'b1;
	#period reset=1'b0; 
	#period  scbar=0;
	//
	data_in=input_vector2;
	for (i=0;i<10;i=i+1)
	begin
	#period;
        end
	if (slv_data==expected_vector1)
	begin
        
	$display ("\n #time=%g, clk=%b, exact data out from slave =%b", $time,sclk,slv_data);
	$display("\n testcase is passed successfuly");
        $display("\n");
        $display("                    **                  ");
	temp_passed_testcases=temp_passed_testcases+1;
	end
        $display("HEY Slave , what data did the Master send you?");
	$display("\n data in to Slave =%b",data_in);
	$display("\n expected data output from slave=%b",expected_vector2);
	for (i=0;i<10;i=i+1)
	begin
	#period;
        end
	if (slv_data==expected_vector2)
	begin
	$display ("\n #time=%g, clk=%b, exact data out from slave =%b", $time,sclk,slv_data);
	$display("\n testcase is passed successfuly");
        $display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\");
	temp_passed_testcases=temp_passed_testcases+1;
	end
	passed_testcases=temp_passed_testcases>=2?
			 passed_testcases+1:passed_testcases;
end
endtask
//****************************||******************************
//***************TestCase3*************************
task testcase3(input [7:0]input_vector0,input [7:0]expected_vector0);
begin
reset=1;
data_in=input_vector0;
sclk=0;
MODE=2'b00;
        $display("############## TestCase (3)----> Mode 0 ############");
	$display("HEY Slave , Show the details of the transmision between you and the master and data master sent to you ");
        $display("\n Current data in Slave =%b",data_in);
	$display("\n expected output data from slave =%b",expected_vector0);
        $display(" time  sclk   MISO  MOSI "); 

# (period)  scbar=1'b0;reset=0;
$monitor(" %g    \t%d  \t%d  \t%d ",$time ,sclk,MISO,MOSI);
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[0]=MISO;
# (period)
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[1]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[2]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[3]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[4]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[5]=MISO;
# (period)  
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[6]=MISO;
#10  
data_out_of_slave[7]=MISO;
if (slv_data==expected_vector0)
	begin
	$display ("\n #time=%g, clk=%b, \n exact data out from slave =%b", $time,sclk,slv_data);
	$display("\n testcase is passed successfuly");
        $display("\n");
        $display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\");
	passed_testcases=passed_testcases+1;
	end
end
endtask
//******************************\\********************
//***************TestCase4*************************
task testcase4(input [7:0]input_vector0,input [7:0]expected_vector0);
begin
reset=1;
data_in=input_vector0;
sclk=1;
MODE=2'b11;
        $display("############## TestCase (4)----> Mode 3 ############");
	$display("HEY Slave , Show the details of the transmision between you and the master and data master sent to you");
        $display("\n Current data in Slave =%b",data_in);
	$display("\n expected output data from slave =%b",expected_vector0);
        $display(" time  sclk   MISO  MOSI "); 


# (period)  scbar=1'b0;reset=0;
$monitor(" %g    \t%d  \t%d  \t%d ",$time ,sclk,MISO,MOSI);
# (period)  
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[0]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[1]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[2]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[3]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[4]=MISO;
# (period) 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[5]=MISO;
# (period) MOSI=1; 
$monitor(" %g    \t%d  \t%d  \t%d  ",$time ,sclk,MISO,MOSI);
data_out_of_slave[6]=MISO;
#10  
data_out_of_slave[7]=MISO;
if (slv_data==expected_vector0)
	begin
	$display ("\n #time=%g, clk=%b, \n exact data out from slave =%b", $time,sclk,slv_data);
	$display("\n testcase is passed successfuly");
        $display("\n");
        $display("//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\");
	passed_testcases=passed_testcases+1;
	end
end
endtask
//******************************\\********************
//***************TestCases1,2,3,4*************************
task testcases1234(input [7:0]input_vector0,input [7:0] expected_vector0,
		   input [7:0]input_vector1,input [7:0] expected_vector1,
		   input [7:0]input_vector2,input [7:0] expected_vector2,
		   input [7:0]input_vector3,input [7:0] expected_vector3);
begin
	passed_testcases=0;
	//readig one byte from master, Mode #2
	//testcase1(input_vector3,expected_vector3);
	//readig two bytes from master, Mode #1
	//testcase2(input_vector2,input_vector1,expected_vector2,expected_vector1);
	//Showing the details of the transmision between the slave and the master
	//i.e. bith of them send and recieve
	testcase3(input_vector0,expected_vector0);
	//Showing the details of the transmision between the slave and the master
	//i.e. bith of them send and recieve
	testcase4(input_vector1,expected_vector1);
	$display("\n\n %d out of 4 testcases passed successfuly\n",passed_testcases);
	passed_testcases=0;

end
endtask
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
