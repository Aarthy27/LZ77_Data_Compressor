module check_end (end_of_data,end_count);
	input [4:0] end_count;
	output reg end_of_data;

	always @ (*) begin
	end_of_data = (end_count==30);
	$display ("end_count",end_count);end
	
endmodule
	
	
	