
module morty_pc_reg #(
		parameter [31:0] RESET_ADDR=32'h0000_0000
		)(
		input 			clk_i,
		input 			rst_i,
		input 			stall,
		input 			flush,
		input 		[31:0] 	pc_i,
	        output reg 	[31:0] 	pc_o); 

	always @(posedge clk_i) begin
		pc_o <= ((rst_i|flush)? (RESET_ADDR):((stall)? pc_o: pc_i));
	end	
endmodule 
