

module morty_mux21 (
		input 	[31:0] in_0,
		input 	[31:0] in_1,
		input    	sel,
		output	reg [31:0] out  ); 

	always @(*) begin
		case(sel)
			1'b0: out = in_0; 
			1'b1: out = in_1;
		endcase
	end
endmodule
		
