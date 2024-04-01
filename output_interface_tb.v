`timescale 1ns/1ns // define simulation timescale

// define testbench module for output_interface
module output_interface_tb();

// define tb registers and wires
reg clk_tb = 0;
reg rst_tb = 0;

reg[127:0] cipher_in;
initial cipher_in = 128'hBC028BD3E0E3B195550D6DF8E6F18241;

reg transformer_done_r;

wire[7:0] data_out;
wire data_ok, output_read;

// define tb->output_interface connections
output_interface i_uut
(
    .clk        (clk_tb),
    .rst_       (rst_tb),

    .transformer_done   (transformer_done_r),
    .ciphertext         (cipher_in),

    .data_out           (data_out),
    .data_ok            (data_ok),
    .output_read        (output_read)

);
// set periodic clock pulse every 1ns
always clk_tb = #1 ~clk_tb;

// set testing sequence signals
initial begin
    // reset output interface
	rst_tb = 0;
	#2;
	rst_tb = 1;
	#2;

    // simulate aes_engine output ready
    transformer_done_r = 1;

    #2;

    // wait for data_ok to go low again
    @(negedge data_ok) begin
        #2;
        $finish;
    end
end

endmodule