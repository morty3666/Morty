`define CPU_ARCH 32
module titan_pc_add(
		input [`CPU_ARCH -1:0] pc,
		output [`CPU_ARCH-1:0] pc_next); 
	
	assign pc_next = pc+32'd4;
		
endmodule 
