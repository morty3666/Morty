
module morty_imm_gen (
			input 	[31:0]	instruction,
			input 	[2:0]	imm_sel_i,
			output 	[31:0]	imm_o	);



		/*verilator lint_off WIDTH*/
		always @(*) begin
			case(imm_sel_i) 
				3'b000: imm_o = $signed({instruction[31:20]});
				3'b001: imm_o = $signed({instruction[31:25],instruction[11:7]});
				3'b010: imm_o = $signed({instruction[31], instruction[7], instruction[30:25], instruction[11:8],1'b0});
				3'b011: imm_o = $signed({instruction[24:20]});
				3'b100: imm_o = $signed({instruction[31],instruction[19:12],instruction[11],instruction[30:20],1'b0});
				3'b101: imm_o = {instruction[31:12],12'b0};
				default: imm_o = 32'b0;
			endcase
		end

endmodule 	
