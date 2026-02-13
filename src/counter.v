module counter (length_count,match_length,ld_length,dec,clk);
	input dec,ld_length,clk;
	input [2:0] match_length;
	output reg [2:0] length_count;
	
	always@(posedge clk) begin
		if(ld_length) 
			length_count<=match_length;
		else if (dec && length_count>0)
		   length_count<=length_count-1;
		//$display ("length_count %d",length_count);
	end
	
endmodule