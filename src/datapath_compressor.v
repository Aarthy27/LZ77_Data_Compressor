module datapath_compressor(clk,rst,data_in,load_input,load_lookahead, load_seach,match_check, encode,slide_search,eqz, end_of_data,ld_length,dec,encoded_data);
	input load_input,load_lookahead,load_seach,clk,rst,encode,slide_search,ld_length,match_check,dec;
	input [7:0] data_in;
	output eqz, end_of_data;
	output [13:0] encoded_data;

	wire [(6*8)-1:0]lookahead_buffer;
	wire [(7*8)-1:0]search_buffer;
	wire [2:0] match_length,match_offset,length_count;
	wire [4:0] read_count;
	wire [7:0] next_char,data_out,inputbuffer_data_out;
	
	
	
	input_buffer ib (clk,rst,data_in,load_input,load_lookahead,inputbuffer_data_out,read_count);
	lookahead_buffer lb (lookahead_buffer,data_out,load_lookahead,clk,rst,inputbuffer_data_out); 
	search_buffer sb (search_buffer,slide_search,load_seach,clk,data_out); 
	match_finder mt (lookahead_buffer,search_buffer,match_check,match_offset,match_length,clk,next_char);
	counter cnt(length_count,match_length,ld_length,dec,clk);
	encoder ed (encoded_data,clk,rst,encode,match_offset,match_length,next_char);
	check_eql eql(eqz,length_count);
	check_end ck(end_of_data,read_count);

	
	endmodule