`timescale 1ns/1ps
module morty_idex_register (
       		input 			clk,
	 	input 			rst, 
		input 			stall,
		input 			bubble,
		input 		[31:0]	id_pc,
		input 		[31:0]	id_instruction,
		input 		[31:0] 	id_porta,
	        input 		[31:0] 	id_portb,
		input 		[ 3:0] 	id_alu_op,
		input 		[ 4:0]	id_rs1,
		input 		[31:0]	id_store_data,
		input 			id_we,
		input 		[ 5:0]	id_mem_flags,
		input 			id_mem_ex_sel,
		input 		[31:0]	id_csr_data,
		input 		[ 2:0] 	id_csr_op,
		input 		[11:0]	id_csr_addr,	
		input 		[4:0] 	id_waddr,
		input 		[ 3:0]	id_exception,
		input 			id_trap_valid,
		input 		[31:0]	id_exc_data,
		input 			id_fence_op,
		input 			id_xret_op,
		output reg	[31:0]	ex_pc,
		output reg 	[31:0]	ex_instruction,
		output reg 	[31:0] 	ex_porta,
		output reg 	[31:0] 	ex_portb,
		output reg 	[ 3:0] 	ex_alu_op,
		output reg 	[ 4:0]	ex_rs1,
		output reg	[31:0]	ex_store_data,
		output reg 		ex_we,
		output reg 	[ 5:0] 	ex_mem_flags,
		output reg 		ex_mem_ex_sel,
		output reg 	[ 3:0]	ex_exception,
		output reg		ex_trap_valid,
		output reg	[31:0]	ex_exc_data,
		output reg		ex_fence_op,
		output reg		ex_xret_op,
		output reg 	[31:0]	ex_csr_data,
		output reg 	[11:0]	ex_csr_addr,
		output reg 	[ 2:0] 	ex_csr_op,
       		output reg 	[ 4:0] 	ex_waddr
	); 


	always @(posedge clk) begin
		ex_instruction 	    	<= ((rst|bubble)? 32'h33 : ((stall)? ex_instruction 		: id_instruction)); 
		ex_pc 	   	    	<= ((rst|bubble)? 32'b0  : ((stall)? ex_pc 			: id_pc)); 
		ex_porta 	    	<= ((rst|bubble)? 32'b0  : ((stall)? ex_porta 			: id_porta)); 
	        ex_portb 	   	<= ((rst|bubble)? 32'b0  : ((stall)? ex_portb 			: id_portb)); 
		ex_alu_op	   	<= ((rst|bubble)? 4'b0   : ((stall)? ex_alu_op			: id_alu_op));
		ex_we    	   	<= ((rst|bubble)? 1'b0   : ((stall)? ex_we    			: id_we   ));
		ex_store_data  	   	<= ((rst|bubble)? 32'h0  : ((stall)? ex_store_data		: id_store_data   ));
		ex_mem_flags	   	<= ((rst|bubble)? 6'b0   : ((stall)? ex_mem_flags	 	: id_mem_flags)); 
		ex_mem_ex_sel	   	<= ((rst|bubble)? 1'b0   : ((stall)? ex_mem_ex_sel	  	: id_mem_ex_sel)); 
		ex_exception		<= ((rst|bubble)? 4'b0	: ((stall)? ex_exception		: id_exception)); 
		ex_trap_valid		<= ((rst|bubble)? 1'b0	: ((stall)? ex_trap_valid		: id_trap_valid)); 
		ex_exc_data		<= ((rst|bubble)? 32'b0	: ((stall)? ex_exc_data			: id_exc_data)); 
		ex_fence_op	    	<= ((rst|bubble)? 1'b0   : ((stall)? ex_fence_op 	  	: id_fence_op));
		ex_xret_op	    	<= ((rst|bubble)? 1'b0   : ((stall)? ex_xret_op 	  		: id_xret_op));
		ex_csr_op	    	<= ((rst|bubble)? 3'b0   : ((stall)? ex_csr_op			: id_csr_op )); 
		ex_csr_addr	    	<= ((rst|bubble)? 12'b0  : ((stall)? ex_csr_addr			: id_csr_addr )); 
		ex_csr_data	    	<= ((rst|bubble)? 32'b0  : ((stall)? ex_csr_data 	  	: id_csr_data)); 
		ex_waddr 	    	<= ((rst|bubble)? 5'b0   : ((stall)? ex_waddr			: id_waddr)); 
		ex_rs1 		    	<= ((rst|bubble)? 5'b0   : ((stall)? ex_rs1			: id_rs1)); 
	end
endmodule

			

