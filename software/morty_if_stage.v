//IF stage XYZ processor

module if_stage
			#(	 parameter [31:0] RESET_ADDR = 32'h0000_0000) //PC at reset
		     (	 input wire clk_i, //clock
				 input wire rst_i,  //reset
				 input wire [31:0] PC_JB_i,  //PC jump or branch
				 input wire [31:0] PC_trap_i, //PC if trap
				 input wire [1:0]  PC_control_i, //Control signal
				 input wire		   PC_en,  //PC enable	

				 output reg [31:0] instr_o,  //fetched instruction
				 output reg [31:0] PC4_if_o, //PC+4
				 output reg [31:0] PC_if_o,  //PC
				 output reg [3:0] trap_code_if_o,  //trap code
				 output reg is_trap_if_o,     //flag for trap
				 output reg  stall_if_o, //stall if in process.
				 //Wishbone
				 output reg [31:0] wbm_addr_if_o,
                 output reg [31:0] wbm_dat_if_o,
                 output reg [ 3:0] wbm_sel_if_o,
                 output reg        wbm_cyc_if_o,
                 output reg        wbm_stb_if_o,
                 output reg        wbm_we_if_o,
                 //
                 input wire [31:0] wbm_dat_if_i,
                 input wire        wbm_ack_if_i,
                 input wire        wbm_err_if_i

			);

		reg [31:0] pc;
		wire [31:0] next_pc;
		wire access_fault;
		wire misaligned_flag;  //flag for instr misaligned

		//Updating PC
		always @(posedge clk_i) begin
			if (rst_i) begin
				pc <= RESET_ADDR;				
			end
			else  begin
			  if(PC_en)
				pc <= next_pc;
			  else 
				pc <= pc;				
			end
			
		end

		
		always @(*) begin
			
			case(PC_control_i)

				2'b00: next_pc=pc+4;    //Just PC+4
				2'b01: next_pc=PC_JB_i;  //If jump/branch
				2'b10: next_pc=PC_trap_i;  //If trap
				default: next_pc=PC_trap_i;

			endcase

			PC4_if_o=pc+4;
			PC_if_o=pc;
			wbm_we_if_o=1'b0;  //Just read memory
			wbm_dat_if_o=32'b0;  //Dont care
			wbm_sel_if_o=4'b1111; //Dont care.
			wbm_addr_if_o=pc;
			instr_o=wbm_dat_if_i;  //Instruction is what comes from memory.

			//Check if pc is aligned
			if(pc[1:0]==2'b0)
				misaligned_flag=1'b0;
			else 
				misaligned_flag=1'b1;

		end

		//state machine

		//States
		localparam start_fetch = 2'b00;
		localparam end_fetch = 2'b01;
		localparam err_fetch = 2'b10;

		reg [1:0] state;  //register to keep current state.
		
		always @(posedge clk_i) begin

			if (rst_i) 
				state <= start_fetch;

			else if (state==start_fetch & wbm_ack_if_i==0 & wbm_err_if_i==0 & misaligned_flag==0) 

				state <= start_fetch;

			else if (state==start_fetch & (wbm_err_if_i==1 | misaligned_flag==1)) 

				state <= err_fetch;
				
			else if (state==start_fetch & wbm_ack_if_i==1) 

				state <= end_fetch;

			else if (state==err_fetch) 

				state <= start_fetch;				

			else if (state==end_fetch & PC_en==1'b1) 

				state <= start_fetch;

			else if (state==end_fetch & PC_en==1'b0) 

				state <= end_fetch;
				
			else 
			    state <= start_fetch;						
						
		end


	  always @(*) begin
	  	
			  	if(state==start_fetch) begin  		
			  	
			  	  	wbm_cyc_if_o=1'b1;
			  	  	wbm_stb_if_o = 1'b1;
			  	  	stall_if_o=1'b1;
			  	  	access_fault=1'b0;
			  	end

			  	else if(state==end_fetch)   begin
			  		wbm_cyc_if_o=1'b0;
			  	  	wbm_stb_if_o = 1'b0;
			  	  	stall_if_o=1'b0;
			  	  	access_fault=1'b0;			  		
			  	end 

			  	else if (state==err_fetch) begin
			  		wbm_cyc_if_o=1'b0;
			  	  	wbm_stb_if_o = 1'b0;
			  	  	stall_if_o=1'b0;
			  	  	if(wbm_err_if_i)
			  	  		access_fault=1'b1;
			  	  	else 
			  	  		access_fault=1'b0;			  		
			  	end
			  	else begin

			  		wbm_cyc_if_o=1'b0;
			  	  	wbm_stb_if_o = 1'b0;
			  	  	stall_if_o=1'b0;
			  	  	access_fault=1'b0;

			  	 	end 		  	 
	  end
    
    //Exceptions
    always @(*) begin

    	if(misaligned_flag)  begin
    		is_trap_if_o=1'b1;
    		trap_code_if_o=4'b0;  //INSTRUCTION MISALIGNED
    	end
    	else if (access_fault) begin
    		is_trap_if_o=1'b1;
    		trap_code_if_o=4'b01;  //ACCESS FAULT  		
    	end
    	else begin
    		is_trap_if_o=1'b0;
    		trap_code_if_o=4'b0;
    		
    	end

    end

   endmodule


