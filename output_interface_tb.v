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

// define tb for dout
reg[127:0] cipher_out;
initial cipher_out = 128'h00000000000000000000000000000000;

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

// set callback for reading data
// read data
always @(negedge clk_tb) begin
    if (data_ok) begin
        // append one byte to cipher_out reading register
        cipher_out = { cipher_out[119:0], data_out };
    end
end

// set testing sequence signals
initial begin
    // reset output interface
	rst_tb = 0;
	#2;
	rst_tb = 1;
	#2;

    // simulate aes_engine output ready
    transformer_done_r = 1;

    // wait for data_ok to go low again
    @(negedge data_ok) begin
        $display("Recieved ciphertext from output_interface: ");
        $write("%02X %02X %02X %02X\n", cipher_out[127:120], cipher_out[95:88], cipher_out[63:56], cipher_out[31:24]);
        $write("%02X %02X %02X %02X\n", cipher_out[119:112], cipher_out[87:80], cipher_out[55:48], cipher_out[23:16]);
        $write("%02X %02X %02X %02X\n", cipher_out[111:104], cipher_out[79:72], cipher_out[47:40], cipher_out[15:8]);
        $write("%02X %02X %02X %02X\n", cipher_out[103:96],  cipher_out[71:64], cipher_out[39:32], cipher_out[7:0]);
        #2;
        $finish;
    end
end

endmodule