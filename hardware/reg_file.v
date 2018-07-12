
module reg_file(
			input clk,
			input [4:0] raddr_rs1,
			input [4:0] raddr_rs2,
			input [4:0] waddr_rd,
			input [31:0] wdata_rd,
			input 	we,
			output [31:0] rdata_rs1, 
			output [31:0] rdata_rs2); 

		reg [31:0] reg_file[31:0]; 
		initial begin
			reg_file[14] = 32'd2;
			reg_file[18] = 32'd4;
		end

		// READ PROCEDURE (COMBINATIONAL)
		assign rdata_rs1 = (raddr_rs1 == 5'd0) ? 32'd0 : reg_file[raddr_rs1]; 
		assign rdata_rs2 = (raddr_rs2 == 5'd0) ? 32'd0 : reg_file[raddr_rs2]; 

		//WRITE PROCEDURE (SEQUENTIAL)
		always @(posedge clk) begin 
			if (we & (waddr_rd != 5'd0)) reg_file[waddr_rd] <= wdata_rd; 
		end 

endmodule


