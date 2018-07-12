//IF stage XYZ processor

module if_stage( input wire	[31:0] RESET_ADDR,	
		     	 input wire clk_i, //clock
				 input wire rst_i,  //reset
				 /* verilator lint_off UNUSED */
				 input wire [31:0] next_PC_JB_i,  //PC jump or branch
				 input wire [31:0] PC_trap_i, //PC if trap
				 input wire [1:0]  next_PC_control_i, //Control signal
				 input wire		   IF_en,  //IF enable
				 input wire        is_stallx_next,	

				 output reg [31:0] instr_o,  //fetched instruction
				 output reg [31:0] PC4_if_o, //PC+4
				 output reg [31:0] PC_if_o,  //PC
				 output reg [3:0] trap_code_if_o,  //trap code
				 output reg is_trap_if_o,     //flag for trap
				 output reg  stall_if_o, //stall if in process.
				 output reg  is_trap_taken,
				 //Wishbone
				 output reg [31:0] wbm_addr_if_o,                 
                 output reg        wbm_cyc_if_o,
                 output reg        wbm_stb_if_o,                 
                 //
                 input wire [31:0] wbm_dat_if_i,
                 input wire        wbm_ack_if_i,
                 input wire        wbm_err_if_i

			);

		reg [31:0] pc;
		wire [31:0] next_pc;
		wire access_fault;
		wire misaligned_flag;  //flag for instr misaligned
		wire PC_en;
		reg [1:0] PC_control;
		reg [31:0] PC_JB;
		wire is_JB = PC_control ==2'b01;
		reg is_stallx;

		assign is_trap_taken = PC_control==2'b10;		

		//Updating PC
		always @(posedge clk_i) begin
			if (rst_i) begin
				pc <= RESET_ADDR;
				PC_control <= 2'b0;
				PC_JB <= 32'b0;
				is_stallx <= 1'b0;				
			end
			else  begin
			  if((IF_en & PC_en) | PC_control==2'b01 &  ~is_stallx  | PC_control==2'b10) 
			  	pc <= next_pc;			  			
			  else 
			  	pc <= pc;
			  PC_control <=next_PC_control_i;
			  PC_JB <= next_PC_JB_i;
			  is_stallx <= is_stallx_next;			  			  

			end
			
		end

		
		always @(*) begin
			
			case(PC_control)

				2'b00: next_pc=pc+4;    //Just PC+4
				2'b01: next_pc={PC_JB[31:1], 1'b0};  //If jump/branch
				2'b10: next_pc=PC_trap_i;  //If trap
				default: next_pc=PC_trap_i;

			endcase

			PC4_if_o=pc+4;
			PC_if_o=pc;			
			wbm_addr_if_o=pc;
			instr_o=wbm_dat_if_i;  //Instruction is what comes from memory.

			//Check if pc is aligned
			if(next_pc[1:0]==2'b0)
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

			else if (state==end_fetch & IF_en==1'b1) 

				state <= start_fetch;

			else if (state==end_fetch & IF_en==1'b0) 

				state <= end_fetch;
				
			else 
			    state <= start_fetch;						
						
		end


	  always @(*) begin
	  	
			  	if(state==start_fetch) begin  		
			  	
			  	  	wbm_cyc_if_o=1'b1;
			  	  	wbm_stb_if_o = 1'b1;
			  	  	PC_en=1'b0;
			  	  	stall_if_o=1'b1;
			  	  	access_fault=1'b0;
			  	end

			  	else if(state==end_fetch)   begin
			  		wbm_cyc_if_o=1'b0;
			  	  	wbm_stb_if_o = 1'b0;			  	  	
			  	  	PC_en=1'b1;			  	  	
			  	  	access_fault=1'b0;
			  	  	if (is_JB) 
			  	  		stall_if_o=1'b1;
			  	  	else
			  	  		stall_if_o=1'b0; 			  		
			  	end 

			  	else if (state==err_fetch) begin
			  		wbm_cyc_if_o=1'b0;
			  	  	wbm_stb_if_o = 1'b0;
			  	  	PC_en=1'b0;
			  	  	stall_if_o=1'b0;
			  	  	if(wbm_err_if_i)
			  	  		access_fault=1'b1;
			  	  	else 
			  	  		access_fault=1'b0;			  		
			  	end
			  	else begin

			  		wbm_cyc_if_o=1'b0;
			  	  	wbm_stb_if_o = 1'b0;
			  	  	PC_en=1'b0;
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



