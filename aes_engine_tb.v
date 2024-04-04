`timescale 1ns/1ns // define simulation timescale

// define testbench module for aes_engine
module aes_engine_tb();

// define tb registers and wires
reg clk_tb = 0;
reg rst_tb = 0;

reg[7:0] din_tb = 0;
reg[1:0] cmd_tb = 0;

wire ready_tb, dok_tb;
wire[7:0] dout_tb;

// define tb for dout
reg[127:0] cipher_out;
initial cipher_out = 128'h00000000000000000000000000000000;

// define tb->aes_engine connections
aes_engine i_uut
(
	.clk(clk_tb),
	.rst_(rst_tb),

	.din(din_tb),
	.cmd(cmd_tb),

	.interface_ready(ready_tb),

	.dout(dout_tb),
	.data_ok(dok_tb)
);

// set periodic clock pulse every 1ns
always clk_tb = #1 ~clk_tb;

// state defines
localparam C_ID = 2'b00;  // Idle state
localparam C_SP = 2'b01;  // Set plaintext state
localparam C_SK = 2'b10;  // Set key state
localparam C_ST = 2'b11;  // Start encryption

// set callback for reading data
// read data
always @(negedge clk_tb) begin
	if (dok_tb) begin
		// append one byte to cipher_out reading register
		cipher_out = { cipher_out[119:0], dout_tb };
	end
end

// set testing sequence signals
initial begin
	// reset everything
	rst_tb = 0;
	#2;
	rst_tb = 1;
	#2;

	// enter plaintext
	cmd_tb = C_SP;
	din_tb = 8'h00;
	#2;
	din_tb = 8'h04;
	#2;
	din_tb = 8'h12;
	#2;
	din_tb = 8'h14;
	#2;
	din_tb = 8'h12;
	#2;
	din_tb = 8'h04;
	#2;
	din_tb = 8'h12;
	#2;
	din_tb = 8'h00;
	#2;
	din_tb = 8'h0C;
	#2;
	din_tb = 8'h00;
	#2;
	din_tb = 8'h13;
	#2;
	din_tb = 8'h11;
	#2;
	din_tb = 8'h08;
	#2;
	din_tb = 8'h23;
	#2;
	din_tb = 8'h19;
	#2;
	din_tb = 8'h19;
	#2;

	// // Idle
	// cmd_tb = C_ID;
	// #2;

	// enter key
	cmd_tb = C_SK;
	din_tb = 8'h24;
	#2;
	din_tb = 8'h75;
	#2;
	din_tb = 8'hA2;
	#2;
	din_tb = 8'hB3;
	#2;
	din_tb = 8'h34;
	#2;
	din_tb = 8'h75;
	#2;
	din_tb = 8'h56;
	#2;
	din_tb = 8'h88;
	#2;
	din_tb = 8'h31;
	#2;
	din_tb = 8'hE2;
	#2;
	din_tb = 8'h12;
	#2;
	din_tb = 8'h00;
	#2;
	din_tb = 8'h13;
	#2;
	din_tb = 8'hAA;
	#2;
	din_tb = 8'h54;
	#2;
	din_tb = 8'h87;
	#2;

	// // Idle
	// cmd_tb = C_ID;
	// #2;

	// Start command
	cmd_tb = C_ST;
	
	// wait for data to be ok to go high
	@(posedge dok_tb)
	begin
		// Idle input interface
		cmd_tb = C_ID;
		// ? OR start inputting next plaintext

		// Read output ciphertext
		// in the routine above
	end

	// Signal read finished
	// wait for data_ok to go low again
	@(negedge dok_tb) begin
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