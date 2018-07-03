

module IMM_EXT(
				input [31:7] inst,
				input [2:0] type_imm, //Señal de control
				output reg [31:0] imm);


	always @(*) begin
		case(type_imm)	
			3'h0: imm = { inst[31:12] , 12'h0 }; //U
			3'h1: imm = { ((inst[31]) ? 20'hfffff : 20'b0), inst[31:20] }; //I
			3'h2: imm = { ((inst[31]) ? 20'hfffff : 20'b0), inst[31], inst[7], inst[30:25], inst[11:8] }; //B
			3'h3: imm = { ((inst[31]) ? 12'hfff   : 12'b0), inst[31], inst[19:12], inst[20], inst[30:21] }; //J
			3'h4: imm = { ((inst[31]) ? 20'hfffff : 20'b0), inst[31:25], inst[11:7] }; //S
			3'h5: imm = { 27'b0 , inst[19:15] }; //CSR
			3'h6: imm = {27'b0, inst[24:20]}; //shamt
			default: imm = 32'b0;
		endcase
	end 
endmodule 
