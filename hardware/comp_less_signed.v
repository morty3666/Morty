


module comp_less_signed(input wire [31:0] in1,
				  		input wire [31:0] in2,
				  		output reg         out	
	              		);

    assign out = ($signed(in1) < $signed(in2)) ;

    endmodule