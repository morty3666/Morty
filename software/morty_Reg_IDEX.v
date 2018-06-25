//FALTAN LAS SEÑALES DE CONTROL
module Register_IDEX(
						input clk,
						input rst,
						input clear_idex,
						input stall_idex,
						//ENTRADAS
						input [4:0] rd_i,
						input [31:0] pc_i,
						input [31:0] pc4_i,
						input [31:0] port_a_i,
						input [31:0] port_b_i,
						input [31:0] r2_i,
						input [11:0] CSR_i,
						input [31:0] drs1_imm_i,
						input [3:0] exc_i,
						//SALIDAS		
						output reg [4:0] rd_o,
						output reg [31:0] pc_o,
						output reg [31:0] pc4_o,
						output reg [31:0] port_a_o,
						output reg [31:0] port_b_o,
						output reg [31:0] r2_o,
						output reg [11:0] CSR_o,
						output reg [31:0] drs1_imm_o,
						output reg [10:0] exc_o);

		always @(posedge clk) begin
			rd_o <= ((clear_idex) || (rst)) ? 5'b0 : ((stall_idex) ? rd_o : rd_i);
			pc_o <= ((clear_idex) || (rst)) ? 32'b0 : ((stall_idex) ? pc_o : pc_i);
			pc4_o <= ((clear_idex) || (rst)) ? 32'b0 : ((stall_idex) ? pc4_o : pc4_i);
			A_o <= ((clear_idex) || (rst)) ? 32'b0 : ((stall_idex) ? A_o : A_i);
			B_o <= ((clear_idex) || (rst)) ? 32'b0 : ((stall_idex) ? B_o : B_i);
			r2_o <= ((clear_idex) || (rst)) ? 32'b0 : ((stall_idex) ? r2_o : r2_i);
			CSR_o <= ((clear_idex) || (rst)) ? 12'b0 : ((stall_idex) ? CSR_o : CSR_i);
			r1_imm_o <= ((clear_idex) || (rst)) ? 32'b0 : ((stall_idex) ? drs1_imm_o : drs1_imm_i);
			exc_o <= ((clear_idex) || (rst)) ? 11'b0 : ((stall_idex) ? exc_o : exc_i);
		end
endmodule 