`timescale 1ns/1ns // define simulation timescale

// define testbench module for input_interface
module input_interface_tb();

// define tb registers and wires
reg clk_tb = 0;
reg rst_tb = 0;

reg[7:0] din_tb = 0;
reg[1:0] cmd_tb = 0;
reg engind = 0;

wire ready_w;
wire enginC_w;
wire[127:0] plain_tb;
wire[127:0] key_tb;

// define tb->input_interface connections
input_interface i_uut
(
	.clk		(clk_tb),
	.rst_		(rst_tb),
	.din		(din_tb),
	.cmd		(cmd_tb),
	.ready		(ready_w),
	.engine_done	(engind),	// AES engine OK signal return
	.engine_start	(enginC_w),	// AES engine START signal send
	.plain_out	(plain_tb),	// -> AES engine PLAINTEXT
	.key_out	(key_tb)	// -> AES engine KEY
);
// set periodic clock pulse every 1ns
always clk_tb = #1 ~clk_tb;

// state defines
localparam C_ID = 2'b00;  // Idle state
localparam C_SP = 2'b01;  // Set plaintext state
localparam C_SK = 2'b10;  // Set key state
localparam C_ST = 2'b11;  // Start encryption
// Enter this into the command console to add a custom radix for this
// radix define InputCommand {2'b00 "ID" -color blue, 2'b01 "SP" -color yellow, 2'b10 "SK" -color orange, 2'b11 "ST" -color red}
// radix define ReadyBusy {0 "BUSY" -color red, 1 "READY" -color blue, -default symbolic}

// set testing sequence signals
initial begin
	engind = 1; // AES engine done / idle
	
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

	// Idle
	cmd_tb = C_ID;
	#2;

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

	// Idle
	cmd_tb = C_ID;
	#2;

	// Start command
	cmd_tb = C_ST;
	engind = 0; // AES engine not done / busy
	#2;
	#2;
	#2;
	#2;
	#2;
	#2;
	#2;
	#2;
	engind = 1; // Engine done
	#2;

	// Idle
	cmd_tb = C_ID;
	#2;
	$finish;
end

endmodule
