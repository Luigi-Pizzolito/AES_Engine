`timescale 1ns/1ns // define simulation timescale

// define testbench module for aes_engine
module aes_engine_tb();

// define tb registers and wires
reg clk_tb = 0;
reg rst_tb = 0;

reg[7:0] din_tb = 0;
reg[1:0] cmd_tb = 0;

//!temp
reg output_read_tb;
initial output_read_tb = 0;

wire ready_tb, done_tb;

// define tb->aes_engine connections
aes_engine i_uut
(
    .clk(clk_tb),
    .rst_(rst_tb),

    .din(din_tb),
    .cmd(cmd_tb),

	//!temp
	.output_read(output_read_tb),

    .interface_ready(ready_tb),
    .engine_done(done_tb)
);

// set periodic clock pulse every 1ns
always clk_tb = #1 ~clk_tb;

// state defines
localparam C_ID = 2'b00;  // Idle state
localparam C_SP = 2'b01;  // Set plaintext state
localparam C_SK = 2'b10;  // Set key state
localparam C_ST = 2'b11;  // Start encryption


// set testing sequence signals
initial begin
	// reset input interface
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
	
	// wait for engine done to go high
	@(posedge done_tb)
	begin
		// Idle input interface
		cmd_tb = C_ID;
		#10;

		// Read output ciphertext

		// Signal read finished
		output_read_tb = 1;

		#10;
		output_read_tb = 0;
		$finish;
	end
	
end

endmodule