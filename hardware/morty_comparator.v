
module morty_comparator (
		   input [2:0] sel, 
		   input [31:0] drs1,
		   input [31:0] drs2, 
		   output reg take_branch ); 

	wire signed [31:0] sdrs1;
	wire signed [31:0] sdrs2;
	wire unsigned [31:0] udrs1;
	wire unsigned [31:0] udrs2;	
	localparam beq 	= 3'h1;
	localparam bne 	= 3'h2;
	localparam blt	= 3'h3;
	localparam bge 	= 3'h4;
	localparam bltu = 3'h5;
	localparam bgeu = 3'h6; 
	localparam nop  = 3'h0;

	assign sdrs1 = drs1;
	assign sdrs2 = drs2;
	assign udrs1 = drs1;
	assign udrs2 = drs2;

	always @(*) begin
		case(sel)
			beq  : take_branch = (sdrs1 == sdrs2);
			bne  : take_branch = (sdrs1 != sdrs2);
			blt  : take_branch = (sdrs1  < sdrs2); 
			bge  : take_branch = (sdrs1 >= sdrs2);
			bltu : take_branch = (udrs1 <  udrs2); 
			bgeu : take_branch = (udrs1 >= udrs2); 
			default  : take_branch = 1'b0;
		endcase
	end 
endmodule

		   

