
module Register_IFID(
						input clk,
						input rst,
						input clear_ifid,
						input stall_ifid,
						//ENTRADAS
						input [31:0] inst_i,
						input [31:0] pc_i,
						input [31:0] pc4_i,
						input [3:0] exc_i,
						//SALIDAS
						output reg [31:0] inst_o,		
						output reg [31:0] pc_o,
						output reg [31:0] pc4_o,
						output reg [3:0] exc_o);

		always @(posedge clk) begin
			pc_o <= ((clear_ifid) || (rst)) ? 32'b0 : ((stall_ifid) ? pc_o : pc_i);
			inst_o <= ((clear_ifid) || (rst)) ? 32'b0 : ((stall_ifid) ? inst_o : inst_i);
			pc4_o <= ((clear_ifid) || (rst)) ? 32'b0 : ((stall_ifid) ? pc4_o : pc4_i);
			exc_o <= ((clear_ifid) || (rst)) ? 11'b0 : ((stall_ifid) ? exc_o : exc_i);
		end
endmodule
