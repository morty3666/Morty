
module Register_MEMWB(
						input clk,
						input rst,
						input clear_memwb,
						input stall_memwb,
						//ENTRADAS
						input [4:0] rd_i,
						input [31:0] pc_i,
						input [31:0] pc4_i,
						input [31:0] data_ALUo_i,
						input [11:0] CSR_i,
						input [31:0] drs1_imm_i,
						input [3:0] exc_i,
						//SALIDAS
						output reg [4:0] rd_o,
						output reg [31:0] pc_o,
						output reg [31:0] pc4_o,
						output reg [31:0] data_ALUo_o,
						output reg [11:0] CSR_o,
						output reg [31:0] drs1_imm_o,
						output reg [10:0] exc_o);

		always @(posedge clk) begin
			rd_o <= ((clear_memwb) || (rst)) ? 5'b0 : ((stall_memwb) ? rd_o : rd_i);
			pc_o <= ((clear_memwb) || (rst)) ? 32'b0 : ((stall_memwb) ? pc_o : pc_i);
			pc4_o <= ((clear_memwb) || (rst)) ? 32'b0 : ((stall_memwb) ? pc4_o : pc4_i);
			data_ALUo_o <= ((clear_memwb) || (rst)) ? 32'b0 : ((stall_memwb) ? data_ALUo_o : data_ALUo_i);
			CSR_o <= ((clear_memwb) || (rst)) ? 12'b0 : ((stall_memwb) ? CSR_o : CSR_i);
			r1_imm_o <= ((clear_memwb) || (rst)) ? 32'b0 : ((stall_memwb) ? drs1_imm_o : drs1_imm_i);
			exc_o <= ((clear_memwb) || (rst)) ? 11'b0 : ((stall_memwb) ? exc_o : exc_i);
		end
endmodule