//Reg MEM WB
module reg_mem_wb ( input wire clk_i,
  					input wire rst_i,
  					input wire clear,
  					input wire en,

  					//From MEM
  					input wire [31:0] PC4_mem,   
					input wire [31:0] PC_mem,     
					input wire [4:0]  rd_mem,      
					input wire [31:0] csr_data_mem,   
					input wire [11:0] csr_addr_mem,    
					input wire [3:0] trap_code_mem,    
					input wire		  is_trap_mem,      
					input wire 		  is_rs0_mem,
					input wire [31:0] data_wb_mem,
					//control
					input wire  we_wb_mem,
		  		    input wire  [1:0] mux_wb_sel_mem,
		  		    input wire  [1:0] csr_op_mem,
		  	    	input wire   comp_mem,
		  		    input wire  is_csr_mem,
		  		    input wire  is_mret_mem,
		  		    input wire  is_FW_mem,
		  		    input wire  is_comp_mem,

  					//To WB
  					output reg [31:0] PC4_wb,   
					output reg [31:0] PC_wb,     
					output reg [4:0] rd_wb,      
					output reg [31:0] csr_data_wb,   
					output reg [11:0] csr_addr_wb,    
					output reg [3:0] trap_code_wb,    
					output reg		  is_trap_wb,      
					output reg 		  is_rs0_wb,
					output reg [31:0] data_wb_wb,
					//control
					output reg  we_wb_wb,
		  		    output reg  [1:0] mux_wb_sel_wb,
		  		    output reg  [1:0] csr_op_wb,
		  	    	output reg   comp_wb,
		  		    output reg  is_csr_wb,
		  		    output reg  is_mret_wb,
		  		    output reg  is_FW_wb,
		  		    output reg  is_comp_wb	 
			  
  					);

  	always @(posedge clk_i) begin
  		if (rst_i) begin

  			PC4_wb <= 32'b0;  
			PC_wb <= 32'b0;    
			rd_wb <= 5'b0;     
			csr_data_wb <= 32'b0; 
			csr_addr_wb <= 12'b0;   
			trap_code_wb <= 4'b0;   
			is_trap_wb <= 1'b0;     
	 		is_rs0_wb <= 1'b0;
	 		data_wb_wb <= 32'b0;
			//control
			we_wb_wb <= 1'b0;
  		    mux_wb_sel_wb <= 2'b0;
  		    csr_op_wb <= 2'b0;
  	    	comp_wb <= 1'b0;
  		    is_csr_wb <= 1'b0;
  		    is_mret_wb	<= 1'b0;
  		    is_FW_wb <= 1'b0;
  		    is_comp_wb <= 1'b0;
  			
  		end
  		else if (clear) begin
  			 
			rd_wb <= 5'b0;     
			csr_data_wb <= 32'b0; 
			csr_addr_wb <= 12'b0;			   
	 		is_rs0_wb <= 1'b0;
	 		data_wb_wb <= 32'b0;
			//control
			we_wb_wb <= 1'b0;
  		    mux_wb_sel_wb <= 2'b0;
  		    csr_op_wb <= 2'b0;
  	    	comp_wb <= 1'b0;
  		    is_csr_wb <= 1'b0;
  		    is_mret_wb	<= 1'b0;
  		    PC4_wb <= PC4_mem;  
			PC_wb <=  PC_mem;
			trap_code_wb <= trap_code_mem;   
			is_trap_wb <= is_trap_mem;
			is_FW_wb <= 1'b0;
			is_comp_wb <= 1'b0;
  		    
           
  		end 		

  		else begin

  			if(en) begin

  				 PC4_wb <= PC4_mem;  
				 PC_wb <=  PC_mem;    
				 rd_wb <= rd_mem;     
				 csr_data_wb <= csr_data_mem; 
				 csr_addr_wb <= csr_addr_mem;   
				 trap_code_wb <= trap_code_mem;   
				 is_trap_wb <= is_trap_mem;     
		 		 is_rs0_wb <= is_rs0_mem;
		 		 data_wb_wb <= data_wb_mem;
				//control
				 we_wb_wb <= we_wb_mem;
	  		     mux_wb_sel_wb <= mux_wb_sel_mem;
	  		     csr_op_wb <= csr_op_mem;
	  	    	 comp_wb <= comp_mem;
	  		     is_csr_wb <= is_csr_mem;
	  		     is_mret_wb	<= is_mret_mem;
	  		     is_FW_wb <= is_FW_mem;
	  		     is_comp_wb <= is_comp_mem;
  				
  			end
  			else begin
				 PC4_wb <= PC4_wb;  
				 PC_wb <=  PC_wb;    
				 rd_wb <= rd_wb;     
				 csr_data_wb <= csr_data_wb; 
				 csr_addr_wb <= csr_addr_wb;   
				 trap_code_wb <= trap_code_wb;   
				 is_trap_wb <= is_trap_wb;     
		 		 is_rs0_wb <= is_rs0_wb;
		 		 data_wb_wb <= data_wb_wb;
				//control
				 we_wb_wb <= we_wb_wb;
	  		     mux_wb_sel_wb <= mux_wb_sel_wb;
	  		     csr_op_wb <= csr_op_wb;
	  	    	 comp_wb <= comp_wb;
	  		     is_csr_wb <= is_csr_wb;
	  		     is_mret_wb	<= is_mret_wb;
	  		     is_FW_wb <= is_FW_wb;
	  		     is_comp_wb <= is_comp_wb;
  			end
  			  			
  		end
  	end

  	endmodule

