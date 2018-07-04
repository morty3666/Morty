	//MEM stage  Jesus Colmenares / 14-11384

`include "LSU.v"
`include "load_unit.v"

// (P) = propagated signals

module MEM_stage(   //inputs
					input wire clk_i,
					input wire [31:0] PC4_mem_i,  //PC+4      (P)
					input wire [31:0] PC_mem_i,  //pc          (P)
					input wire [4:0] rd_mem_i,  //RD ADDRESS    (P)
					input wire [31:0] alu_out_mem_i,  //ALU RESULT FROM EX 
					input wire [31:0] rs2_data_mem_i,  //DATA FROM RS2  - WISHBONE DATA TO MEMORY
					input wire [31:0] csr_data_mem_i,  //DATA TO BE USED BY CSR     (P)
					input wire [11:0] csr_addr_mem_i,  //CSR ADDRESS                 (P)
					input wire [3:0] trap_code_mem_i,  //EXCEPTION CODE             (P)
					input wire is_trap_mem_i,  //TRAP FLAG                            (P)
					input wire is_rs0_i,       //(P)
					input wire we_mem_ctrl_i,  //Control Signal
					input wire is_LS_mem_ctrl_i, //Control Signal
					input wire [2:0] funct3_mem_ctrl_i,  //Control Signal
					input wire data_or_alu_ctrl_i, //Control signal - 1 for MEM 0 for alu
					input wire  wbm_ack_mem_i, //WB
					input wire  wbm_err_mem_i, //WB
					input wire [31:0] wbm_data_mem_i,  //WB
					
					

					//Outputs
					output reg [31:0] PC4_mem_o,   // (P)
					output reg [31:0] PC_mem_o,     // (P)
					output reg [4:0] rd_mem_o,      // (P)
					output reg [31:0] csr_data_mem_o,   // (P)
					output reg [11:0] csr_addr_mem_o,    // (P)
					output reg [3:0] trap_code_mem_o,    // (P)
					output reg		  is_trap_mem_o,      // (P)
					output reg 		  is_rs0_o,   // (P)
					output reg [31:0] wbm_addr_mem_o,  //WB
                 	output reg [31:0] wbm_dat_mem_o,	//WB
                 	output reg [ 3:0] wbm_sel_mem_o,	//WB
                 	output reg        wbm_cyc_mem_o, 	//WB
                 	output reg        wbm_stb_mem_o,	//WB
                 	output reg        wbm_we_mem_o,	    //WB	        			  
					output reg [31:0] data_or_alu_o,   //Data from memory or alu, use to WB.
					output reg	 		  stall_mem_o   //This is used to stall datapath when using memory
				);

		localparam SB=3'b000;
		localparam SH=3'b001;
		localparam SW=3'b010;
	

		always @(*) begin

				//Propagated signals to next stage
				PC4_mem_o = PC4_mem_i;
				PC_mem_o = PC_mem_i;
				rd_mem_o =  rd_mem_i;
				csr_data_mem_o = csr_data_mem_i;  
				csr_addr_mem_o = csr_addr_mem_i;  
			    trap_code_mem_o = trap_code_mem_i;  
				is_trap_mem_o = is_trap_mem_i;
				is_rs0_o=is_rs0_i;

				//Signals to memory
				wbm_addr_mem_o= {alu_out_mem_i[31:2], 2'b0};
				wbm_dat_mem_o = rs2_data_mem_i;
				wbm_we_mem_o = we_mem_ctrl_i;
			
		end
		/* 

		always @(*) begin
			case(1'b1)
				SB: begin
					case(alu_out_mem_i[1:0])
						2'b00: wbm_dat_mem_o = rs2_data_mem_i;
						2'b01: wbm_dat_mem_o = {rs2_data_mem_i[23:0], 8'b0};
						2'b10: wbm_dat_mem_o = {rs2_data_mem_i[15:0], 16'b0};
						2'b11: wbm_dat_mem_o = {rs2_data_mem_i[31:24], 24'b0};
					endcase
				end
				SH: begin
					case(alu_out_mem_i[1])
						1'b0: wbm_dat_mem_o = rs2_data_mem_i;
						1'b1: wbm_dat_mem_o = {rs2_data_mem_i[15:0], 16'b0};
					endcase					
				end
				default: wbm_dat_mem_o = rs2_data_mem_i;
			endcase
			
		end   */


		 wire [31:0] data_mem_chosen;  //Correct data from memory (LB,LH,LW...)

		 LSU LSU_ins(clk_i,is_LS_mem_ctrl_i, funct3_mem_ctrl_i, alu_out_mem_i[1:0], wbm_ack_mem_i, wbm_err_mem_i, wbm_sel_mem_o, wbm_cyc_mem_o, wbm_stb_mem_o, stall_mem_o);

		 load_unit load_unit_ins(wbm_data_mem_i, funct3_mem_ctrl_i, alu_out_mem_i[1:0], data_mem_chosen);

		 assign data_or_alu_o = data_or_alu_ctrl_i ? data_mem_chosen : alu_out_mem_i ;  //MUX choose between alu result or data from memory

	 endmodule



		
