module check_eql (eqz,length_count);
	input [2:0] length_count;
	output eqz;
	
	assign eqz = (length_count==0);
	
endmodule