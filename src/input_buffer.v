module input_buffer (clk,rst,data_in,load_input,load,data_out,read_count);
	input [7:0] data_in;
	input clk,rst,load_input,load;
	output reg [7:0] data_out;
	output [4:0] read_count;
	
	reg [7:0] input_buffer [29:0] ;
	reg [4:0]rd_ptr;    //=1;
	reg [4:0]wr_ptr;    //=0;
	
	always@ (posedge clk)
	begin
		if (load_input && wr_ptr<=29) begin
				if(wr_ptr==0) begin
					data_out <= data_in;
					//$display ("Input CHECK",data_out);
					end
				input_buffer[wr_ptr] <= data_in;
				wr_ptr  <=  wr_ptr+1; end
				$display ("WRITE DONE : ",input_buffer[wr_ptr-1]);
	
		if(rst) begin
			rd_ptr<=1;
			wr_ptr<=0; end
		else if(load && rd_ptr<=29) begin
			data_out <= input_buffer[rd_ptr];
			//$display ("Input CHECK (READ)",data_out);
			rd_ptr <= rd_ptr+1; end		
	end
	
	assign read_count = rd_ptr;
	 
endmodule