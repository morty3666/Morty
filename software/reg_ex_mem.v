//Reg EX MEM


 module reg_ex_mem( input wire clk_i,
  					input wire rst_i,
  					input wire clear,
  					input wire en,

  					//From EX
  					input wire [6:0]  opcode_ex,
  					input wire [31:0] PC4_ex,
					input wire [31:0] PC_ex,
					input wire [4:0]  rd_ex,		
					input wire [31:0] csr_data_ex,
					input wire [11:0] csr_addr_ex,
					input wire [31:0] rs2_data_ex,
					input wire [3:0] trap_code_ex, 
					input wire is_trap_ex, 
					input wire is_rs0_ex,
					input wire [31:0] alu_out_ex,
					//control
					input wire  we_mem_ex,
		  		    input wire  is_LS_ex,
		  		    input wire  [2:0] funct3_mem_ex,
		  		    input wire  data_or_alu_ex,
		  		    input wire  we_wb_ex,
		  		    input wire  [1:0] mux_wb_sel_ex,
		  		    input wire  [1:0] csr_op_ex,
		  	    	input wire   comp_ex,
		  		    input wire  is_csr_ex,
		  		    input wire  is_mret_ex, 
		  		    input wire  is_FW_ex,
		  		    input wire is_comp_ex,
  					//To MEM
  					output reg [6:0]  opcode_mem,
  					output reg [31:0] PC4_mem,
					output reg [31:0] PC_mem,
					output reg [4:0]  rd_mem,		
					output reg [31:0] csr_data_mem,
					output reg [11:0] csr_addr_mem,
					output reg [31:0] rs2_data_mem,
					output reg [3:0] trap_code_mem, 
					output reg is_trap_mem, 
					output reg is_rs0_mem,
					output reg [31:0] alu_out_mem,
					//control
					output reg  we_mem_mem,
		  		    output reg  is_LS_mem,
		  		    output reg  [2:0] funct3_mem_mem,
		  		    output reg  data_or_alu_mem,
		  		    output reg  we_wb_mem,
		  		    output reg  [1:0] mux_wb_sel_mem,
		  		    output reg  [1:0] csr_op_mem,
		  	    	output reg   comp_mem,
		  		    output reg  is_csr_mem,
		  		    output reg  is_mret_mem, 
		  		    output reg is_FW_mem,
		  		    output reg is_comp_mem
  					);

  	always @(posedge clk_i) begin
  		if (rst_i) begin

  			opcode_mem <= 7'b0;
  			PC4_mem <= 32'b0;
			PC_mem <= 32'b0;
			rd_mem <= 5'b0;		
			csr_data_mem <= 32'b0;
			csr_addr_mem <= 12'b0;
			rs2_data_mem <= 32'b0;
		    trap_code_mem <= 4'b0; 
			is_trap_mem <= 1'b0; 
			is_rs0_mem <= 1'b0;
			alu_out_mem <= 32'b0;
			//control
			we_mem_mem <= 1'b0;
  		    is_LS_mem <= 1'b0;
  		    funct3_mem_mem <= 3'b0;
  		    data_or_alu_mem <= 1'b0;
  		    we_wb_mem <= 1'b0;
  		    mux_wb_sel_mem <= 2'b0;
  		    csr_op_mem <= 2'b0;
  	    	comp_mem <= 1'b0;
  		    is_csr_mem <= 1'b0;
  		    is_mret_mem <= 1'b0;
  		    is_FW_mem <=1'b0;
  		    is_comp_mem <= 1'b0;
  			
  		end
  		else if (clear) begin

  			opcode_mem <= 7'b0;  			
			rd_mem <= 5'b0;		
			csr_data_mem <= 32'b0;
			csr_addr_mem <= 12'b0;
			rs2_data_mem <= 32'b0;
		    is_rs0_mem <= 1'b0;
			alu_out_mem <= 32'b0;
			//control
			we_mem_mem <= 1'b0;
  		    is_LS_mem <= 1'b0;
  		    funct3_mem_mem <= 3'b0;
  		    data_or_alu_mem <= 1'b0;
  		    we_wb_mem <= 1'b0;
  		    mux_wb_sel_mem <= 2'b0;
  		    csr_op_mem <= 2'b0;
  	    	comp_mem <= 1'b0;
  		    is_csr_mem <= 1'b0;
  		    is_mret_mem <= 1'b0;
  		    PC4_mem <= PC4_ex;
			PC_mem <= PC_ex;
			trap_code_mem <= trap_code_ex; 
			is_trap_mem <= is_trap_ex;
			is_FW_mem <=1'b0;
			 is_comp_mem <= 1'b0;
  		             
  		end 		

  		else begin

  			if(en) begin
  				opcode_mem <= opcode_ex; 
  				PC4_mem <= PC4_ex;
				PC_mem <= PC_ex;
				rd_mem <= rd_ex;		
				csr_data_mem <= csr_data_ex;
				csr_addr_mem <= csr_addr_ex;
				rs2_data_mem <= rs2_data_ex;
			    trap_code_mem <= trap_code_ex; 
				is_trap_mem <= is_trap_ex; 
				is_rs0_mem <= is_rs0_ex;
				alu_out_mem <= alu_out_ex;
				//control
				we_mem_mem <= we_mem_ex;
	  		    is_LS_mem <= is_LS_ex;
	  		    funct3_mem_mem <= funct3_mem_ex;
	  		    data_or_alu_mem <= data_or_alu_ex;
	  		    we_wb_mem <= we_wb_ex;
	  		    mux_wb_sel_mem <= mux_wb_sel_ex;
	  		    csr_op_mem <= csr_op_ex;
	  	    	comp_mem <=  comp_ex;
	  		    is_csr_mem <= is_csr_ex;
	  		    is_mret_mem <= is_mret_ex;
	  		    is_FW_mem <= is_FW_ex;
	  		     is_comp_mem <= is_comp_ex;
  			end
  			else begin
  				opcode_mem <= opcode_mem; 
  				PC4_mem <= PC4_mem;
				PC_mem <= PC_mem;
				rd_mem <= rd_mem;		
				csr_data_mem <= csr_data_mem;
				csr_addr_mem <= csr_addr_mem;
				rs2_data_mem <= rs2_data_mem;
			    trap_code_mem <= trap_code_mem; 
				is_trap_mem <= is_trap_mem; 
				is_rs0_mem <= is_rs0_mem;
				alu_out_mem <= alu_out_mem;
				//control
				we_mem_mem <= we_mem_mem;
	  		    is_LS_mem <= is_LS_mem;
	  		    funct3_mem_mem <= funct3_mem_mem;
	  		    data_or_alu_mem <= data_or_alu_mem;
	  		    we_wb_mem <= we_wb_mem;
	  		    mux_wb_sel_mem <= mux_wb_sel_mem;
	  		    csr_op_mem <= csr_op_mem;
	  	    	comp_mem <=  comp_mem;
	  		    is_csr_mem <= is_csr_mem;
	  		    is_mret_mem <= is_mret_mem;
	  		    is_FW_mem <= is_FW_mem;
	  		    is_comp_mem <= is_comp_mem;
  			end
  			  			
  		end
  	end

  	endmodule