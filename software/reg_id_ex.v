//Reg ID-EX

module reg_id_ex(   input wire clk_i,
  					input wire rst_i,
  					input wire clear,
  					input wire en,

  					//From ID
               input wire [6:0]  opcode_id,
  					input wire [4:0]  rd_id,
  					input wire [31:0] PC4_id,
  					input wire [31:0] PC_id,
  					input wire [31:0] port_a_id,
  					input wire [31:0] port_b_id,
  					input wire [11:0] CSR_addr_id,
  					input wire [31:0] CSR_data_id,
  					input wire [3:0]  trap_code_id,
  					input wire 		  is_trap_id,
  					input wire [31:0] drs2_id,  //forwb
  					input wire is_rs0_id,
  					//From control
  					input wire we_mem_id,
					input wire is_LS_id,
					input wire [2:0] funct3_mem_id,
					input wire data_or_alu_id,
					input wire [2:0] alu_op_ex_id,
					input wire we_wb_id,
					input wire [1:0] mux_wb_sel_id,
					input wire [1:0] csr_op_id,
					input wire comp_id,
					input wire is_csr_id,
					input wire is_mret_id,  //Flag for CSR to mret instr.
                    input wire is_FW_id,
                    input wire is_comp_id,
					

					//To EX
               output reg [6:0]  opcode_ex,
					output reg [4:0]  rd_ex,
  					output reg [31:0] PC4_ex,
  					output reg [31:0] PC_ex,
  					output reg [31:0] port_a_ex,
  					output reg [31:0] port_b_ex,
  					output reg [11:0] CSR_addr_ex,
  					output reg [31:0] CSR_data_ex,
  					output reg [3:0]  trap_code_ex,
  					output reg 		  is_trap_ex,
  					output reg [31:0] drs2_ex,  //forwb
  					output reg 		  is_rs0_ex,
  					//
  					output reg we_mem_ex,
  					output reg is_LS_ex,
  					output reg [2:0] funct3_mem_ex,
  					output reg data_or_alu_ex,
  					output reg [2:0] alu_op_ex_ex,
  					output reg we_wb_ex,
  					output reg [1:0] mux_wb_sel_ex,
  					output reg [1:0] csr_op_ex,
  					output reg comp_ex,
  					output reg is_csr_ex,
  					output reg is_mret_ex,
                    output reg is_FW_ex,
                    output reg is_comp_ex			
					);
						

  	always @(posedge clk_i) begin
  		if (rst_i) begin

         opcode_ex <= 7'b0;
  			rd_ex <= 5'b0;
  			PC4_ex <= 32'b0;
  			PC_ex <= 32'b0;
  			port_a_ex <= 32'b0;
  			port_b_ex <= 32'b0;
  			CSR_addr_ex <= 12'b0;
  			CSR_data_ex <= 32'b0;
  			trap_code_ex <= 4'b0;
  			is_trap_ex <= 1'b0;
  			drs2_ex <=  32'b0;
 			we_mem_ex <= 1'b0;
 			is_LS_ex <= 1'b0;
 			funct3_mem_ex <= 3'b0;
 			data_or_alu_ex <= 1'b0;
  			alu_op_ex_ex <= 3'b0;
 			we_wb_ex <= 1'b0;
  			mux_wb_sel_ex <= 2'b0;
  			csr_op_ex <= 2'b0;
 			comp_ex <= 1'b0;
 			is_csr_ex <= 1'b0;
 			is_mret_ex <= 1'b0;
 			is_rs0_ex <= 1'b0;
            is_FW_ex <=1'b0;
            is_comp_ex <=1'b0;

  		end
  		else if (clear) begin

            opcode_ex <= 7'b0;  		
  			rd_ex <= 5'b0;
  			port_a_ex <= 32'b0;
  			port_b_ex <= 32'b0;
  			CSR_addr_ex <= 12'b0;
  			CSR_data_ex <= 32'b0;
  			drs2_ex <=  32'b0;
 			we_mem_ex <= 1'b0;
 			is_LS_ex <= 1'b0;
 			funct3_mem_ex <= 3'b0;
 			data_or_alu_ex <= 1'b0;
  			alu_op_ex_ex <= 3'b0;
 			we_wb_ex <= 1'b0;
  			mux_wb_sel_ex <= 2'b0;
  			csr_op_ex <= 2'b0;
 			comp_ex <= 1'b0;
 			is_csr_ex <= 1'b0;
 			is_mret_ex <= 1'b0;
 			is_rs0_ex <= 1'b0;
            PC4_ex <= PC4_id;
            PC_ex <= PC_id;
            trap_code_ex <= trap_code_id;
            is_trap_ex <= is_trap_id;
            is_FW_ex <=1'b0;
            is_comp_ex <=1'b0;
            
            
 		end		

  		else begin

  			if(en) begin

             opcode_ex <= opcode_id;
			    rd_ex <= rd_id;
			    PC4_ex <= PC4_id;
			    PC_ex <= PC_id;
			    port_a_ex <= port_a_id;
			    port_b_ex <= port_b_id;
			    CSR_addr_ex <= CSR_addr_id;
			    CSR_data_ex <= CSR_data_id;
			    trap_code_ex <= trap_code_id;
			    is_trap_ex <= is_trap_id;
			    drs2_ex <=  drs2_id;
			    we_mem_ex <= we_mem_id;
			    is_LS_ex <= is_LS_id;
			    funct3_mem_ex <= funct3_mem_id;
			    data_or_alu_ex <= data_or_alu_id;
			    alu_op_ex_ex <= alu_op_ex_id;
			    we_wb_ex <= we_wb_id;
			    mux_wb_sel_ex <= mux_wb_sel_id;
			    csr_op_ex <= csr_op_id;
			    comp_ex <= comp_id;
			    is_csr_ex <= is_csr_id;
			    is_mret_ex <= is_mret_id;
			    is_rs0_ex <= is_rs0_id;
                is_FW_ex <= is_FW_id;
                is_comp_ex <= is_comp_id;
  				
  			end
  			else begin
            opcode_ex <= opcode_ex;
			    rd_ex <= rd_ex;
			    PC4_ex <= PC4_ex;
			    PC_ex <= PC_ex;
			    port_a_ex <= port_a_ex;
			    port_b_ex <= port_b_ex;
			    CSR_addr_ex <= CSR_addr_ex;
			    CSR_data_ex <= CSR_data_ex;
			    trap_code_ex <= trap_code_ex;
			    is_trap_ex <= is_trap_ex;
			    drs2_ex <=  drs2_ex;
			    we_mem_ex <= we_mem_ex;
			    is_LS_ex <= is_LS_ex;
			    funct3_mem_ex <= funct3_mem_ex;
			    data_or_alu_ex <= data_or_alu_ex;
			    alu_op_ex_ex <= alu_op_ex_ex;
			    we_wb_ex <= we_wb_ex;
			    mux_wb_sel_ex <= mux_wb_sel_ex;
			    csr_op_ex <= csr_op_ex;
			    comp_ex <= comp_ex;
			    is_csr_ex <= is_csr_ex;
			    is_mret_ex <= is_mret_ex;
			    is_rs0_ex <= is_rs0_ex;
                is_FW_ex <= is_FW_ex;
                is_comp_ex <= is_comp_ex;
  			end
  			  			
  		end
  	end

  	endmodule
