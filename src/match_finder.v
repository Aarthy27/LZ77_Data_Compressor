module match_finder(lookahead_in,search_in,match_check,match_offset,match_length,clk,next_char);
	parameter DATA_WIDTH=8;
	parameter SEARCH_SIZE=7;
	parameter LOOKAHEAD_SIZE=6;
	
	input [(SEARCH_SIZE*DATA_WIDTH)-1:0] search_in;
	input [(LOOKAHEAD_SIZE*DATA_WIDTH)-1:0] lookahead_in;
	input clk;
	input match_check;
	output reg [2:0] match_offset;
   output reg [2:0] match_length;
	output reg [DATA_WIDTH-1:0] next_char;
	
	reg [DATA_WIDTH-1:0] search [0:SEARCH_SIZE-1];
   reg  [DATA_WIDTH-1:0] lookahead [0:LOOKAHEAD_SIZE-1];
	
	integer ptr;
	reg [2:0]length;


	integer x,y,i, k,temp_i,temp_k,cur_k,stop;
	
   always @(posedge clk) begin
		if(match_check) begin
		ptr=0;			
		for (x = 0; x < 48; x = x + 8) 
		begin
			lookahead[ptr] = lookahead_in[x +: 8];  // Extract 8 bits 
			ptr=ptr+1;
		end
		ptr=0;
		for (y = 0; y < 56; y = y + 8) 
		begin
			search[ptr] = search_in[y +: 8];  // Extract 8 bits 
			ptr=ptr+1;
		end
		
		 /* 
		 $display ("Lookahead 5 %d",lookahead[5]);
		 $display ("Lookahead 4 %d",lookahead[4]);
		 $display ("Lookahead 3 %d",lookahead[3]);
		 $display ("Lookahead 2 %d",lookahead[2]);
		 $display ("Lookahead 1 %d",lookahead[1]);
		 $display ("Lookahead 0 %d",lookahead[0]);
		 
		 $display ("search 6 %d",search[6]);
		 $display ("search 5 %d",search[5]);
		 $display ("search 4 %d",search[4]);
		 $display ("search 3 %d",search[3]);
		 $display ("search 2 %d",search[2]);
		 $display ("search 1 %d",search[1]);
		 $display ("search 0 %d",search[0]);*/
		 
		 
		 
		 match_length = 0;
       match_offset = 0;
		 next_char=lookahead[LOOKAHEAD_SIZE-1];
		 cur_k = 0;
		 
		 
		 for (i = SEARCH_SIZE-1; i >= 0; i = i - 1) begin
		 //$display ("i = %d",i);
				//for (k = LOOKAHEAD_SIZE-1; k >= 0; k = k - 1) begin
				//$display ("k = %d",k);
				k = LOOKAHEAD_SIZE-1;
				length=0;
					if(search[i]==lookahead[k]) begin
					   length=length+1;
					   //$display ("First_length= %d ",length);	
						temp_i = i-1;
						stop=0;
						for(temp_k = k-1; temp_k > 0 ;temp_k=temp_k-1) begin
							if(temp_i >= 0) begin
						   if(search[temp_i]==lookahead[temp_k] && stop!=1) begin
								cur_k=temp_k-1;
								temp_i=temp_i-1;
								length=length+1;
								//$display ("second_length= %d ",length);
							end
							else
								stop=1;
							end
						end
					end
					//$display ("length= %d ",length);
					
					if(temp_i+1 == 0 && match_length < LOOKAHEAD_SIZE-1)
					begin
						stop=0;
						for(temp_i = LOOKAHEAD_SIZE-1; temp_i > 0 ;temp_i=temp_i-1) begin
							if(length < LOOKAHEAD_SIZE-1 && lookahead[temp_i]==lookahead[cur_k] && stop!=1) begin
								cur_k=cur_k-1;
								length = length+1;
								//$display ("third_length= %d ",length);
							end
							else
								stop=1;
							
						end
					end
				//$display ("length= %d ",length);
				
				if (length > match_length) begin
                match_length = length;
                match_offset = i+(SEARCH_SIZE-1)-k;
					 next_char = lookahead[k-length];
					 //$display ("append_length= %d ",length);
					 //$display ("append_offset= %d ",offset);
            end
				
				
		 end
		 
		$display ("-----Match Check-----"); 
		$display ("match_offset = %d ",match_offset);
		$display ("match_length = %d ",match_length);
		$display ("next_char = %c ",next_char);
		end 
		 
		 
 end
endmodule		
