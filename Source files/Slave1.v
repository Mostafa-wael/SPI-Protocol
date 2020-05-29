//#(parameter MODE=3)
module slave (input[1:0] MODE,input reg [7:0] data_in,input reset,input clk,
	      input MOSI , output reg MISO,input CS,output reg [7:0] data_out);
reg entered=0;

reg [7:0] R_data;
reg [7:0] T_data; 
reg done;//
integer count=0;
reg is_read=0;
//wire sclk;
//assign sclk= (MODE==2'b00||MODE==2'b11)?~clk:clk;

always@(posedge clk)
begin
//if(MODE==2'b00||MODE==2'b11)
//begin
if((reset||!is_read))
begin
T_data=data_in;
count=0;
entered=0;
done=0;
end
//end
if(!CS)
begin
    //if(MODE==2'b00||MODE==2'b11)
    //  begin
     if(entered)
      begin
      R_data={MOSI,R_data[7:1]};
      count=count+1;  
        if(count==8)
        begin 
        count=0;
        entered=0; 
        data_out=R_data;
        is_read=0;
        done=1; 
        end
        
      end 
    //  end
    /*else if(MODE==2'b10||MODE==2'b01)
      if(!done)
        begin       
        MISO=T_data[7];
        T_data={T_data[6:0],1'bx};   
        entered=1;
        is_read=1; 
        end*/

end
end

always@(negedge clk)
begin
/*if(MODE==2'b01||MODE==2'b10)
begin*/
if((reset||!is_read))
begin
T_data=data_in;
count=0;
entered=0;
done=0;
end
//end
if(!CS)
begin
    /*if(MODE==2'b01||MODE==2'b10)
      begin
     if(entered)
      begin
      R_data={MOSI,R_data[7:1]};
      count=count+1;  
        if(count==8)
        begin 
        count=0;
        entered=0; 
        data_out=R_data;
        is_read=0;
        done=1;       
        end 
      end 
      end
    else if(MODE==2'b00||MODE==2'b11)*/
      if(!done)
        begin       
        MISO=T_data[7];
        T_data={T_data[6:0],1'bx};   
        entered=1;
        is_read=1; 
        end


      
end
end

endmodule
