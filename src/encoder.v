module encoder(encoded_data,clk,rst,encode,match_offset,match_length,next_char);
	input clk,rst,encode;
	input [2:0] match_offset,match_length;
	input [7:0] next_char;
	output reg [13:0]encoded_data;
	
	always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_data <= 0;
		  end 
		  else begin
            if (encode) begin
                encoded_data <= {match_offset, match_length, next_char};
					 $display("ENCODED DATA %b",encoded_data);
            end 
		  end 
	end
	
endmodule