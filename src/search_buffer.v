module search_buffer(buffer_out,shift,rst,clk,data_in);
    input rst,clk,shift;
    input [7:0] data_in;
	 output [(7*8)-1:0]buffer_out;
	 
    reg [7:0] search_buffer [0:6]; //SEARCH_SIZE = 7

    integer i;
    always @(posedge clk) 
	 begin
		  if (shift) begin
				for (i = 6; i > 0; i = i - 1) begin
						search_buffer[i] <= search_buffer[i-1];
						//$display ("res %d %d",i,search_buffer[i+1]); 
						end
						search_buffer[0] <= data_in;
					
		  end
		  
		  /*else if(rst) begin
				for(i=0;i<7;i=i+1)
				search_buffer[i]<=1'bx; 
				end*/
		  
		 $display ("search_buffer[6] = %c",search_buffer[6]);
		 $display ("search_buffer[5] = %c",search_buffer[5]);
		 $display ("search_buffer[4] = %c",search_buffer[4]);
		 $display ("search_buffer[3] = %c",search_buffer[3]);
		 $display ("search_buffer[2] = %c",search_buffer[2]);
		 $display ("search_buffer[1] = %c",search_buffer[1]);
		 $display ("search_buffer[0] = %c",search_buffer[0]);
				
    end
	 assign buffer_out = {search_buffer[6], 
                  search_buffer[5], 
                  search_buffer[4], 
                  search_buffer[3], 
                  search_buffer[2], 
                  search_buffer[1],
						search_buffer[0]
                  };
endmodule
