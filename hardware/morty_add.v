
module morty_add(
			input [31:0] in1,
			input [31:0] in2,
			output reg [31:0] out);

	assign out = in1 + in2;
	
endmodule
