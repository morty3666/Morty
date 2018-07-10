



module comp_equal(input wire [31:0] in1,
				  input wire [31:0] in2,
				  output reg         out	
	              );

	assign out = (in1==in2) ;

	endmodule

