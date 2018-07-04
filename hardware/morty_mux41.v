

module morty_mux41 (

		input 	[31:0] in_0,
		input 	[31:0] in_1,
		input   [31:0] in_2,
		input  	[31:0] in_3,
		input   [ 1:0] 	sel,
		output	reg [31:0] out  ); 

	always @(*) begin
		case(sel)
			2'b0  : out = in_0; 
			2'b1  : out = in_1;
			2'b10 : out = in_2;
			2'b11 : out = in_3;
		endcase
	end
endmodule
		
