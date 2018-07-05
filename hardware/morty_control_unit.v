

module morty_control_unit (
			input 		 rst_i,
			input 		 if_stall_req_i,
			input   	 mem_stall_req_i,
			input 		 csr_stall_req_i,
			input 		 illegal_stall_req_i,
			input 		 ld_stall_req_i,
			input 		 xcall_break_stall_req_i,
			input 		 branch_flush_req_i,
			input 		 jump_flush_req_i,
			input 		 exception_stall_req_i,
			output 		 if_kill_o,
			output reg [1:0] if_pc_sel_o,
			output 		 if_stall_o, 
			output 		 id_stall_o,
			output 		 ex_stall_o,
			output  	 mem_stall_o,
			output 		 wb_stall_o,
			output 	 	 if_flush_o,
			output 	 	 id_flush_o,
			output 	 	 ex_flush_o,
			output 	 	 mem_flush_o,
			output 		 wb_flush_o, //always null?
			output 		 ex_nop_o  ); 

		wire 	illegal_nop;
			
		assign  wb_stall_o  = 0;
		assign 	mem_stall_o = mem_stall_req_i ;
		assign 	ex_stall_o  = mem_stall_o; 
		assign  id_stall_o  = ex_stall_o | ex_nop_o; 
		assign  if_stall_o  = if_stall_req_i | id_stall_o | ld_stall_req_i ; 
		
       		//NOPS 
		assign ex_nop_o     =  ld_stall_req_i | csr_stall_req_i ; 
		assign illegal_nop  =  illegal_stall_req_i;	
		//FLUSHES
		assign if_kill_o    = (jump_flush_req_i | branch_flush_req_i) & ~(ex_nop_o);
		assign if_flush_o   = rst_i; 
		assign id_flush_o   = (if_stall_req_i & ~(id_stall_o))| illegal_nop | if_kill_o | rst_i | exception_stall_req_i | xcall_break_stall_req_i;
		assign ex_flush_o   =  rst_i | exception_stall_req_i ;
		assign mem_flush_o  =  rst_i | exception_stall_req_i;
		assign wb_flush_o   =  rst_i | mem_stall_req_i; 

		always @(*) begin
			case(1'b1)
				branch_flush_req_i: 	if_pc_sel_o = 2'b01;
				jump_flush_req_i: 	if_pc_sel_o = 2'b10;
				exception_stall_req_i:	if_pc_sel_o = 2'b11;
				default: 		if_pc_sel_o = 2'b00;
			endcase
		end 
		
endmodule 	

