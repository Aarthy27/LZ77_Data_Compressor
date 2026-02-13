module lz77_controller(
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire        eqz,
    input  wire        end_of_data,  

    output reg         load_input,
    output reg         load_lookahead,
    output reg         load_seach,   
    output reg         match_check,
    output reg         encode,
    output reg         slide_search,
    output reg         done,
    output reg         ld_length,
    output reg         dec,
    output reg 	       encoded_valid
);

    parameter lookahead_size = 6;
    

    parameter
        IDLE   = 3'b000,
        START  = 3'b001,
        LOAD   = 3'b010,
        MATCH  = 3'b011,
        ENCODE = 3'b100,
        SLIDE  = 3'b101,
        DONE   = 3'b110;

    reg [2:0] state, next_state;

    integer count, load_data;
    integer next_count, next_load_data;

    always @(posedge clk or posedge rst) begin
	     $display ("-----------CLOCK POSEDGE------------");
	     $display ("-----State = %d------",state);
        if (rst) begin
            state      <= IDLE;
            count      <= 0;
            load_data  <= 0;
        end else begin
            state      <= next_state;
            count      <= next_count;
            load_data  <= next_load_data;
        end
    end


    always @(*) begin
        // default next values (hold state)
        next_state     = state;
        next_count     = count;
        next_load_data = load_data;

        // default outputs
        load_input     = 0;
        load_lookahead = 0;
        load_seach     = 0;
        match_check    = 0;
        encode         = 0;
        slide_search   = 0;
        done           = 0;
        ld_length      = 0;
        dec            = 0;
	encoded_valid  = 0;

        case (state)
            //-----------------------------------------
            IDLE: begin
                if (start) begin
                    next_state     = START;
                    next_load_data = 0;
                end
            end

            //-----------------------------------------
            START: begin
                load_input = 1;

                if (load_data < 2) begin
                    next_state     = START;
                    next_load_data = load_data + 1;
                end else begin
                    next_state = LOAD;
                    next_count = 0;
                end
            end

            //-----------------------------------------
            LOAD: begin
                load_input     = 1;
                load_lookahead = 1;
                load_seach     = 1;

                if (count == lookahead_size - 1) begin
                    next_state = MATCH;
                end else begin
                    next_state = LOAD;
                    next_count = count + 1;
                end
            end

            //-----------------------------------------
            MATCH: begin
                load_input  = 1;
                match_check = 1;

                next_state = ENCODE;
            end

            //-----------------------------------------
            ENCODE: begin
                load_input = 1;
                encode     = 1;
                ld_length  = 1;
		encoded_valid  = 1;

                next_state = SLIDE;
            end

            //-----------------------------------------
            SLIDE: begin
                load_input     = 1;
                load_lookahead = 1;
                slide_search   = 1;
                dec            = 1;

                if (eqz) begin
                    if (end_of_data)
                        next_state = DONE;
                    else
                        next_state = MATCH;
                end
            end

            //-----------------------------------------
            DONE: begin
                done = 1;
                next_state = DONE; 
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
