/*module tb_lz77_file();

    reg clk, rst, start;
    reg [7:0] data_in;
    wire done,encoded_valid;
    wire [13:0] encoded_data;

    integer infile, outfile;
    integer char_read;

    integer input_bits;
    integer output_bits;

    // Instantiate the top-level LZ77 module
    lz77_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .done(done),
        .encoded_data(encoded_data),
	.encoded_valid(encoded_valid)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst   = 1;
        start = 0;
        data_in = 0;

        input_bits  = 0;
        output_bits = 0;

        // Open files
        infile  = $fopen("C:/Users/ARTHY/OneDrive/Desktop/LZ77_Compressor/input.txt", "r");
        outfile = $fopen("compressed.txt", "w");

        if (infile == 0) begin
            $display("ERROR: Cannot open input file");
            $finish;
        end

        // Reset
        #20 rst = 0;

        // Start compression
        @(posedge clk);
        start = 1;

        // Read file byte-by-byte
        while (!$feof(infile)) begin
            char_read = $fgetc(infile);
            if (char_read != -1) begin
                @(posedge clk);
                data_in = char_read[7:0];
                input_bits = input_bits + 8;
            end
        end

        // Stop input
        @(posedge clk);
        start = 0;
        data_in = 8'b0;

        // Wait for compression to complete
        wait(done == 1);
        #20;

        // Display statistics
        $display("=================================");
        $display("Input bits      = %0d", input_bits);
        $display("Compressed bits = %0d", output_bits);
        $display("Compression Ratio = %f",
                  input_bits * 1.0 / output_bits);
        $display("=================================");

        $fclose(infile);
        $fclose(outfile);

        $stop;
    end

    // Capture compressed output
    always @(posedge clk) begin
        if (done == 0 && encoded_valid == 1) begin
            // Write every encoded output
            $fwrite(outfile, "%b\n", encoded_data);
            output_bits = output_bits + 14;
        end
    end

    // Optional monitor
    initial begin
        $monitor("%t ns: Encoded = %b Done = %b",
                  $time, encoded_data, done);
    end

endmodule*/


module tb_lz77_file();

    reg clk, rst, start;
    reg [7:0] data_in;
    wire done, encoded_valid;
    wire [13:0] encoded_data;

    integer infile, outfile;
    integer char_read;

    integer input_bits;
    integer output_bits;

    // -------- THROUGHPUT VARIABLES --------
    integer cycle_count;
    integer start_cycle;
    integer end_cycle,total_cycle;
    real    time_taken;
    real    throughput;
    parameter CLK_PERIOD_NS = 10; // 100 MHz
    // -------------------------------------

    // Instantiate the top-level LZ77 module
    lz77_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .done(done),
        .encoded_data(encoded_data),
        .encoded_valid(encoded_valid)
    );

    // Clock generation
    always #5 clk = ~clk;

    // -------- CLOCK CYCLE COUNTER --------
    always @(posedge clk) begin
        cycle_count = cycle_count + 1;
    end
    // ------------------------------------

    initial begin
        clk   = 0;
        rst   = 1;
        start = 0;
        data_in = 0;

        input_bits  = 0;
        output_bits = 0;
        cycle_count = 0;
        start_cycle = 0;
        end_cycle   = 0;
	total_cycle = 0;

        // Open files
        infile  = $fopen("C:/Users/ARTHY/OneDrive/Desktop/Project/INPUTS/input1.txt", "r");
        outfile = $fopen("compressed.txt", "w");

        if (infile == 0) begin
            $display("ERROR: Cannot open input file");
            $finish;
        end

        // Reset
        #20 rst = 0;

        // Start compression
        @(posedge clk);
        start = 1;
        start_cycle = cycle_count;   // <-- START CYCLE

        // Read file byte-by-byte
        while (!$feof(infile)) begin
            char_read = $fgetc(infile);
            if (char_read != -1) begin
                @(posedge clk);
                data_in = char_read[7:0];
                input_bits = input_bits + 8;
            end
        end

        // Stop input
        @(posedge clk);
        start = 0;
        data_in = 8'b0;

        // Wait for compression to complete
        wait(done == 1);
        end_cycle = cycle_count;     // <-- END CYCLE
        #20;

        // -------- THROUGHPUT CALCULATION --------
        time_taken = (end_cycle - start_cycle)
                     * CLK_PERIOD_NS * 1e-9;

        throughput = input_bits / time_taken;
	total_cycle = end_cycle - start_cycle;
        // ---------------------------------------

        // Display statistics
        $display("=========================================");
        $display("Input bits         = %0d", input_bits);
        $display("Compressed bits    = %0d", output_bits);
        $display("Total cycles       = %0d",
                 end_cycle - start_cycle);
	$display("Compression Ratio  = %f",
                 input_bits * 1.0 / output_bits);
	$display("Compression Gain (Percentage) = %f",
         (1.0 - (output_bits * 1.0 / input_bits)) * 100.0);
        $display("Time taken (sec)   = %e", time_taken);
        $display("Throughput (bps)   = %f", throughput);
        $display("Throughput (Bytes / Cycle)  = %f", input_bits * 1.0/total_cycle);
        
        $display("=========================================");

        $fclose(infile);
        $fclose(outfile);

        $stop;
    end

    // Capture compressed output
    always @(posedge clk) begin
        if (done == 0 && encoded_valid == 1) begin
            $fwrite(outfile, "%b\n", encoded_data);
            output_bits = output_bits + 14;
        end
    end

    // Optional monitor
    initial begin
        $monitor("%t ns: Encoded = %b Done = %b",
                  $time, encoded_data, done);
    end

endmodule
