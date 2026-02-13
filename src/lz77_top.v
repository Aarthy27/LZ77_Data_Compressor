module lz77_top(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output done,
    output [13:0] encoded_data,
    output encoded_valid
);

    // Internal control signals
    wire load_input,load_lookahead, load_seach, encode,slide_search,match_check;
    wire eqz, end_of_data;
    wire ld_length, dec;

    // Instantiate datapath
    datapath_compressor dp(            
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
		  .load_input(load_input),
        .load_lookahead(load_lookahead),
        .load_seach(load_seach),
		  .match_check(match_check),
        .encode(encode),
		  .slide_search(slide_search),
        .eqz(eqz),
        .end_of_data(end_of_data),
        .ld_length(ld_length),
        .dec(dec),
        .encoded_data(encoded_data)  
    );

    // Instantiate controller
    lz77_controller cnr(
        .clk(clk),
        .rst(rst),
        .start(start),
        .eqz(eqz),
        .end_of_data(end_of_data),
		  .load_input(load_input),
        .load_lookahead(load_lookahead),
        .load_seach(load_seach),
		  .match_check(match_check),
        .encode(encode),
		  .slide_search(slide_search),
        .done(done),
        .ld_length(ld_length),
        .dec(dec),
	.encoded_valid(encoded_valid)
    );

endmodule
