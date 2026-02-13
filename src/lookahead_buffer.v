module lookahead_buffer(buffer_out,data_out,load,clk,rst,data_in);
	parameter DATA_WIDTH=8;
	parameter LOOKAHEAD_SIZE=6;
	
	input load,clk,rst;
	input [DATA_WIDTH-1:0]data_in;
	output [(LOOKAHEAD_SIZE*DATA_WIDTH)-1:0]buffer_out;
	output [DATA_WIDTH-1:0] data_out;
	
	reg [DATA_WIDTH-1:0] lookahead_window [0:LOOKAHEAD_SIZE];
	
	integer ptr;//=0;
	integer i,j;
	
	always @(posedge clk)
	begin
																						
		if (load) //left shifts single bit 
		begin
			for(j=LOOKAHEAD_SIZE-1;j>0;j=j-1)
				lookahead_window[j]<=lookahead_window[j-1];
			lookahead_window[0]<=data_in;	
		end 
		
		else if(rst) begin
			ptr<=0;
			for(i=0;i<LOOKAHEAD_SIZE;i=i+1)
				lookahead_window[i]<=0; end
			
			$display ("lookahead_window[5] = %c",lookahead_window[5]);
			$display ("lookahead_window[4] = %c",lookahead_window[4]);
			$display ("lookahead_window[3] = %c",lookahead_window[3]);
			$display ("lookahead_window[2] = %c",lookahead_window[2]);
			$display ("lookahead_window[1] = %c",lookahead_window[1]);
			$display ("lookahead_window[0] = %c",lookahead_window[0]);
			
	end
	
	assign buffer_out = {lookahead_window[5], 
                  lookahead_window[4], 
                  lookahead_window[3], 
                  lookahead_window[2], 
                  lookahead_window[1], 
                  lookahead_window[0]
                  };
	assign data_out =lookahead_window[LOOKAHEAD_SIZE-1];
	
		
endmodule