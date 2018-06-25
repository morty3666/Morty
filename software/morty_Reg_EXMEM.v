//FALTAN SEÑALES DE CONTROL 
module Register_EXMEM(
						input clk,
						input rst,
						input clear_exmem,
						input stall_exmem,
						//ENTRADAS
						input [4:0] rd_i,
						input [31:0] pc_i,
						input [31:0] pc4_i,
						input [31:0] ALUo_i,
						input [31:0] r2_i,
						input [11:0] CSR_i,
						input [31:0] drs1_imm_i,
						input [3:0] exc_i,
						//SALIDAS
						output reg [4:0] rd_o,
						output reg [31:0] pc_o,
						output reg [31:0] pc4_o,
						output reg [31:0] ALUo_o,
						output reg [31:0] r2_o,
						output reg [11:0] CSR_o,
						output reg [31:0] drs1_imm_o,
						output reg [10:0] exc_o);

		always @(posedge clk) begin
			rd_o <= ((clear_exmem) || (rst)) ? 5'b0 : ((stall_exmem) ? rd_o : rd_i);
			pc_o <= ((clear_exmem) || (rst)) ? 32'b0 : ((stall_exmem) ? pc_o : pc_i);
			pc4_o <= ((clear_exmem) || (rst)) ? 32'b0 : ((stall_exmem) ? pc4_o : pc4_i);
			ALUo_o <= ((clear_exmem) || (rst)) ? 32'b0 : ((stall_exmem) ? ALUo_o : ALUo_i);
			r2_o <= ((clear_exmem) || (rst)) ? 32'b0 : ((stall_exmem) ? r2_o : r2_i);
			CSR_o <= ((clear_exmem) || (rst)) ? 12'b0 : ((stall_exmem) ? CSR_o : CSR_i);
			r1_imm_o <= ((clear_exmem) || (rst)) ? 32'b0 : ((stall_exmem) ? drs1_imm_o : drs1_imm_i);
			exc_o <= ((clear_exmem) || (rst)) ? 11'b0 : ((stall_exmem) ? exc_o : exc_i);
		end
endmodule