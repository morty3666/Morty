//XYZ PROCESSOR CORE

`include "if_stage.v"
`include "reg_if_id.v"
`include "ID_Stage.v"
`include "control_unit.v"
`include "reg_id_ex.v"
`include "ex_stage.v"
`include "reg_ex_mem.v"
`include "MEM_stage.v"
`include "reg_mem_wb.v"
`include "WB_stage.v"
`include "hazard_unit.v"
//

  module xyz #( parameter [31:0] HART_ID = 32'b0,
                parameter [31:0] RESET_ADDR = 32'h8000_0000,
                parameter ENABLE_COUNTERS = 1'b0,
                parameter ENABLE_M_ISA =1'b0,
                parameter UCONTROL = 1'b0
                )
  			 ( 
  			   //Wishbone interface with instruction memory
  			   output reg [31:0] iwbm_addr_o,
               output reg        iwbm_cyc_o,
               output reg        iwbm_stb_o,               
               output reg [31:0] dwbm_addr_o,
               output reg [31:0] dwbm_dat_o,
               output reg [ 3:0] dwbm_sel_o,
               output reg        dwbm_cyc_o,
               output reg        dwbm_stb_o,
               output reg        dwbm_we_o,
               //
               input wire clk_i,
               input wire rst_i,
               //
               input wire [31:0] iwbm_dat_i,
               input wire        iwbm_ack_i,
               input wire        iwbm_err_i,
               input wire [31:0] dwbm_dat_i,
               input wire        dwbm_ack_i,
               input wire        dwbm_err_i ,
               // external interrupts interface
               input wire        xint_meip_i,
               input wire        xint_mtip_i,
               input wire        xint_msip_i              
               
  			 	);


  			 //IF signals
  			 wire [31:0] PC_JB_if;  			 
  			 wire IF_en;
  			 wire [31:0] instr_if;
  			 wire [31:0]  PC_if, PC4_if;
  			 wire  is_trap_if;
  			 wire [3:0]  trap_code_if;
             //--------------------------------------------------------------------------------------------------------------------------
  			 //ID signals
			 wire [31:0] instr_id;
  			 wire [31:0] PC4_id_i;
  			 wire [31:0] PC_id_i;
  			 wire [31:0] PC4_id_o;
  			 wire [31:0] PC_id_o;
  			 wire [3:0] trap_code_id_i;
  			 wire is_trap_id_i;
  			 //
  			 wire [3:0] trap_code_id_o;
  			 wire is_trap_id_o;  			
			 wire [4:0] rd_id;				
			 wire [31:0] port_a_id;  //ALU scr A
			 wire [31:0] port_b_id;  //ALU scr B						
			 wire [11:0] CSR_addr_id;  //CSR address
			 wire [31:0] CSR_data_id;
			 wire [3:0] trap_code_id;
			 wire [31:0] forw_b_id; //data en rs2 corregida con FW
			 wire is_rs0_id;
			 wire equal_id, ltu_id, lts_id;
            //--------------------------------------------------------------------------------------------------------------------------
			 //EX signals
			 wire [6:0] opcode_ex;
			 wire [31:0] PC4_ex_i; //PC+4
			 wire [31:0] PC_ex_i;  //PC
			 wire [4:0]  rd_ex_i;  //rd address for WB stage
			 wire [31:0] src_A_ex_i; //alu input
			 wire [31:0] src_B_ex_i;  //alu input			 
			 wire [31:0] csr_data_ex_i; //data for CSR
			 wire [11:0] csr_addr_ex_i; //CSR address
			 wire [31:0] rs2_data_ex_i; //Data from rs2 to be written in MEM
			 wire [3:0] trap_code_ex_i; 
			 wire is_trap_ex_i; //flag for exceptions
			 wire is_rs0_ex_i;
			 wire [31:0] data_from_wb;
			 //
			 wire [31:0] PC4_ex_o;
		     wire [31:0] PC_ex_o;
		     wire [4:0]  rd_ex_o;		
		     wire [31:0] csr_data_ex_o;
		     wire [11:0] csr_addr_ex_o;
		     wire [31:0] rs2_data_ex_o;
		     wire [3:0] trap_code_ex_o; 
		     wire is_trap_ex_o; 
		     wire is_rs0_ex_o;
		     wire [31:0] alu_out_ex_o;  //alu result after execution.
            //--------------------------------------------------------------------------------------------------------------------------
		     //MEM signals
		     wire [6:0] opcode_mem;
		     wire [31:0] PC4_mem_i;
			 wire [31:0] PC_mem_i;
			 wire [4:0]  rd_mem_i;		
		     wire [31:0] csr_data_mem_i;
			 wire [11:0] csr_addr_mem_i;
			 wire [31:0] rs2_data_mem_i;
			 wire [3:0] trap_code_mem_i; 
			 wire is_trap_mem_i; 
			 wire is_rs0_mem_i;
			 wire [31:0] alu_out_mem_i;
			 //
	 		wire [31:0] PC4_mem_o;   
			wire [31:0] PC_mem_o;     
			wire [4:0] rd_mem_o;     
			wire [31:0] csr_data_mem_o; 
			wire [11:0] csr_addr_mem_o;    
			wire [3:0] trap_code_mem_o;   
			wire		  is_trap_mem_o;     
			wire 		  is_rs0_mem_o;
			wire [31:0]   data_wb_mem;   
            //--------------------------------------------------------------------------------------------------------------------------
  			 //WB signals

  			wire [31:0] PC4_wb;   
			wire [31:0] PC_wb;     
			wire [4:0] rd_wb_i;      
			wire [31:0] csr_data_wb;   
			wire [11:0] csr_addr_wb;    
			wire [3:0] trap_code_wb;    
			wire		  is_trap_wb_i;
			wire		  is_trap_wb_o;      
			wire 		  is_rs0_wb;
			wire [31:0] data_wb_wb;
			//
			wire [4:0] rd_wb_o; 		
			 wire is_PC_csr;
             wire [31:0] CSR_data_out;
			 assign is_PC_csr = is_trap_wb_o | is_mret_wb;
             //--------------------------------------------------------------------------------------------------------------------------	

  			 //Hazard signals
  			 wire stall_if;
  			 wire stall_mem;
  			 wire [3:0] rst_stages;
  			 wire [3:0] en_stages;
  			 wire [31:0] fexc; 
		     wire [31:0] fmem;
			 wire [31:0] fwb; 
			 wire [1:0] ctrl_forwa; //SEL MUX FW1
			 wire [1:0] ctrl_forwb; //SEL MUX FW2
             //--------------------------------------------------------------------------------------------------------------------------
             //forwarding
             always @(*) begin

                if(is_comp_ex)
                    fexc = {31'b0, comp_ex};
                else 
                    fexc = alu_out_ex_o;

                if(is_comp_mem)
                    fmem = {31'b0, comp_mem};
                else 
                    fmem = data_wb_mem;

                if(is_comp_wb)
                    fwb = {31'b0,comp_wb};
                else 
                    fwb = data_from_wb;              
                 
             end
            
             //--------------------------------------------------------------------------------------------------------------------------

			 //Control signals
             //
			 wire	  branch_taken_id;  //For hazard unit
			  //Control signals in ID
			 wire [1:0] PC_control_if;
			 wire [1:0] ctrl_muxa, ctrl_muxb;
             wire is_FW_id;
             /* verilator lint_off UNOPTFLAT */
			 wire  ctrl_muxcsr, ctrl_muxj;			
			 wire [2:0] type_imm;
			 wire we_mem_id;
			 wire is_LS_id;
			 wire [2:0] funct3_mem_id;
			 wire data_or_alu_id;
			 wire [2:0] alu_op_ex_id;
			 wire we_wb_id;
			 wire [1:0] mux_wb_sel_id;
			 wire [1:0] csr_op_id;
			 wire comp_id, is_comp_id;
			 wire is_csr_id;
			 wire is_mret_id;  //Flag for CSR to mret instr.
			 wire is_trap_decode;
			 wire [3:0] cause_trap_decode;
			   //Control signals in EX
			wire  we_mem_ex;
  		    wire  is_LS_ex;
  		    wire  [2:0] funct3_mem_ex;
            wire is_FW_ex;
  		    wire  data_or_alu_ex;
  		    wire  [2:0] alu_op_ex_ex;
  		    wire  we_wb_ex;
  		    wire  [1:0] mux_wb_sel_ex;
  		    wire  [1:0] csr_op_ex;
  	    	wire   comp_ex, is_comp_ex;
  		    wire  is_csr_ex;
  		    wire  is_mret_ex;
  		    	//Control signals in MEM
  		    wire  we_mem_mem;
  		    wire  is_LS_mem;
  		    wire  [2:0] funct3_mem_mem;
  		    wire  data_or_alu_mem;
  		    wire  we_wb_mem;
  		    wire  [1:0] mux_wb_sel_mem;
  		    wire  [1:0] csr_op_mem;
  	    	wire   comp_mem, is_comp_mem;
  		    wire  is_csr_mem;
  		    wire  is_mret_mem;
            wire is_FW_mem;
  		    	//Control signals in WB  		    
  		    wire  we_wb_wb_i;
  		    wire  we_wb_wb_o;
  		    wire  [1:0] mux_wb_sel_wb;
  		    wire  [1:0] csr_op_wb;
  	    	wire   comp_wb, is_comp_wb;
  		    wire  is_csr_wb;
  		    wire  is_mret_wb;
            wire is_FW_wb;

            //--------------------------------------------------------------------------------------------------------------------------	
			 
			 //Regs between stages
			 wire rst1, rst2, rst3, rst4;
			 assign rst1 = rst_i | rst_stages[3];
			 assign rst2 = rst_i | rst_stages[2];
			 assign rst3 = rst_i | rst_stages[1];
			 assign rst4 = rst_i | rst_stages[0];
             //--------------------------------------------------------------------------------------------------------------------------
             //Exception handling between stages

             wire is_trap_if_o;
             wire [3:0] trap_code_if_o;
             wire is_trap_id_oo;
             wire [3:0] trap_code_id_oo;
             wire is_trap_ex_oo;
             wire [3:0] trap_code_ex_oo;
             wire is_trap_mem_oo;
             wire [3:0] trap_code_mem_oo;
                
                always @(*) begin
                 
                 if(is_trap_if) begin
                     is_trap_if_o =1'b1;
                     trap_code_if_o =trap_code_if;
                 end
                 else begin
                    is_trap_if_o = 1'b0;
                    trap_code_if_o = 4'b0;                     
                 end

                 if(is_trap_id_o) begin
                     is_trap_id_oo =1'b1;
                     trap_code_id_oo =trap_code_id_o;
                 end
                 else begin
                    is_trap_id_oo = is_trap_decode;
                     trap_code_id_oo = cause_trap_decode;                     
                 end

                 if(is_trap_ex_o) begin
                     is_trap_ex_oo =1'b1;
                     trap_code_ex_oo =trap_code_ex_o;
                 end
                 else begin
                    is_trap_ex_oo =1'b0;
                    trap_code_ex_oo = 4'b0;                    
                 end

                 if(is_trap_mem_o) begin
                     is_trap_mem_oo =1'b1;
                     trap_code_mem_oo =trap_code_mem_o;
                 end
                 else begin
                    is_trap_mem_oo =1'b0;
                     trap_code_mem_oo = 4'b0;                    
                 end
                 
             end

             //--------------------------------------------------------------------------------------------------------------------------

             //Modules instantiation


  			 //IF stage
  			 if_stage IF_ins(clk_i,
  			 				 rst_i,
  			 				 PC_JB_if,
  			 				 CSR_data_out,   //PC for trap
  			 				 PC_control_if,
  			 				 IF_en,
  			 				 instr_if,
  			 				 PC4_if,
  			 				 PC_if,
  			 				 trap_code_if,
  			 				 is_trap_if,
  			 				 stall_if,
  			 				 iwbm_addr_o,  			 				
  			 				 iwbm_cyc_o,
                             iwbm_stb_o,
                             iwbm_dat_i,
                             iwbm_ack_i,
                             iwbm_err_i
                             );


  			 //Reg from IF to ID
  			 reg_if_id reg_if_id_ins(clk_i,
  			 						 rst1, //rst
  			 						 is_trap_if_o,  //clear is trap in IF
  			 						 en_stages[3],
  			 						 //From IF
  			 						 instr_if,
  			 						 PC4_if,
  			 						 PC_if,
  			 						 trap_code_if_o,
  			 						 is_trap_if_o,
  			 						 //To ID
  			 						 instr_id,
  			 						 PC4_id_i,
  			 						 PC_id_i,
  			 						 trap_code_id_i,
  			 						 is_trap_id_i
  			 						 );

  			 ID_Stage id_stage_ins( clk_i,
  			 						instr_id,
  			 						PC_id_i,
  			 						PC4_id_i,
  			 						we_wb_wb_o,
  			 						rd_wb_o,
  			 						data_from_wb,
  			 						trap_code_id_i,
  			 						is_trap_id_i,
  			 						//forwarding
  			 						fexc, 
		    						fmem,
									fwb, 
									ctrl_forwa, //SEL MUX FW1
									ctrl_forwb, //SEL MUX FW2
									//Control signals
									ctrl_muxa,
									ctrl_muxb,
									ctrl_muxcsr,
									ctrl_muxj,
									type_imm,
									//To next stage
									rd_id,
									PC_id_o,
  			 						PC4_id_o,
									port_a_id,
									port_b_id,
                                    PC_JB_if,									
									CSR_addr_id,
									CSR_data_id,
									trap_code_id_o,
									forw_b_id,
									is_trap_id_o,
									is_rs0_id,
									equal_id, ltu_id, lts_id
  			 						);


  			 control_unit control_ins(instr_id,
  			 						  equal_id,
  			 						  ltu_id,
  			 						  lts_id,
  			 						  is_PC_csr,
  			 						  //outputs
  			 						  PC_control_if,
  			 						  ctrl_muxa,
  			 						  ctrl_muxb,
  			 						  ctrl_muxcsr,
  			 						  ctrl_muxj,
  			 						  type_imm,
  			 						  we_mem_id,
  			 						  is_LS_id,
  			 						  funct3_mem_id,
  			 						  data_or_alu_id,
  			 						  alu_op_ex_id,
  			 						  we_wb_id,
  			 						  mux_wb_sel_id,
  			 						  csr_op_id,
  			 						  comp_id,
                                      is_comp_id,
  			 						  is_csr_id,
  			 						  is_mret_id,
  			 						  is_trap_decode,
  			 						  cause_trap_decode,
  			 						  branch_taken_id,
                                      is_FW_id
  			 						  );

  			 //Reg from ID to EX
  			 reg_id_ex reg_id_ex_ins( clk_i,
  			 						  rst2,
  			 						  is_trap_id_oo, //clear if trap in ID
  			 						  en_stages[2],
  			 						  //From ID
  			 						  instr_id[6:0],
									  rd_id,
									  PC4_id_o,
									  PC_id_o,  			 						
									  port_a_id,
									  port_b_id,
									  CSR_addr_id,
									  CSR_data_id,
									  trap_code_id_oo,  //CHECK
									  is_trap_id_oo,   //CHECK
									  forw_b_id,									
									  is_rs0_id,
									  //from control
									  we_mem_id,
  			 						  is_LS_id,
  			 						  funct3_mem_id,
  			 						  data_or_alu_id,
  			 						  alu_op_ex_id,
  			 						  we_wb_id,
  			 						  mux_wb_sel_id,
  			 						  csr_op_id,
  			 						  comp_id,
  			 						  is_csr_id,
  			 						  is_mret_id,
                                      is_FW_id,
                                      is_comp_id,
  			 						  //To EX
  			 						  opcode_ex,
  			 						  rd_ex_i,
  			 						  PC4_ex_i,
  			 						  PC_ex_i,
  			 						  src_A_ex_i,
  			 						  src_B_ex_i,
  			 						  csr_addr_ex_i,
  			 						  csr_data_ex_i,
  			 						  trap_code_ex_i,
  			 						  is_trap_ex_i,
  			 						  rs2_data_ex_i,
  			 						  is_rs0_ex_i,
  			 						  //control propagated
			                          we_mem_ex,
  		                              is_LS_ex,
  		                              funct3_mem_ex,
  		                              data_or_alu_ex,
  		                              alu_op_ex_ex,
  		                              we_wb_ex,
  		                              mux_wb_sel_ex,
  		                              csr_op_ex,
  	    	                          comp_ex,
  		                              is_csr_ex,
  		                              is_mret_ex,
                                      is_FW_ex,
                                      is_comp_ex
  		                              );

  			 ex_stage ex_stage_ins( PC4_ex_i,
  			 						PC_ex_i,
  			 						rd_ex_i,
  			 						src_A_ex_i,
  			 						src_B_ex_i,
  			 						alu_op_ex_ex,
  			 						csr_data_ex_i,
  			 						csr_addr_ex_i,
  			 						rs2_data_ex_i,  			 						
  			 						trap_code_ex_i,
  			 						is_trap_ex_i,  			 						
  			 						is_rs0_ex_i,
  			 						//
						  			PC4_ex_o,
								    PC_ex_o,
								    rd_ex_o,		
								    csr_data_ex_o,
								    csr_addr_ex_o,
								    rs2_data_ex_o,
								    trap_code_ex_o, 
								    is_trap_ex_o, 
								    is_rs0_ex_o,
								    alu_out_ex_o  //alu result after execution.
								    );

  			 reg_ex_mem reg_ex_mem_ins( clk_i,
  			 							rst3,
  			 							is_trap_ex_oo,
  			 							en_stages[1],
  			 							//From EX
  			 							opcode_ex,
  			 							PC4_ex_o,
										PC_ex_o,
										rd_ex_o,		
										csr_data_ex_o,
										csr_addr_ex_o,
										rs2_data_ex_o,
									    trap_code_ex_oo, 
										is_trap_ex_oo, 
										is_rs0_ex_o,
										alu_out_ex_o,
										//control
										we_mem_ex,
							  		    is_LS_ex,
							  		    funct3_mem_ex,
							  		    data_or_alu_ex,
							  		    we_wb_ex,
							  		    mux_wb_sel_ex,
							  		    csr_op_ex,
							  	    	comp_ex,
							  		    is_csr_ex,
							  		    is_mret_ex,
                                        is_FW_ex,
                                        is_comp_ex,
							  		    //To MEM
							  		    opcode_mem,
							  		    PC4_mem_i,
			                            PC_mem_i,
			                            rd_mem_i,		
		                                csr_data_mem_i,
			                            csr_addr_mem_i,
		                                rs2_data_mem_i,
	                                    trap_code_mem_i, 
                                        is_trap_mem_i, 
	                                    is_rs0_mem_i,
			                            alu_out_mem_i,
			                            //control
			                            we_mem_mem,
  		                                is_LS_mem,
  		                                funct3_mem_mem,
  		                                data_or_alu_mem,
  		                                we_wb_mem,
  		                                mux_wb_sel_mem,
  		                                csr_op_mem,
  	    	                            comp_mem,
  		                                is_csr_mem,
  		                                is_mret_mem,
                                        is_FW_mem,
                                        is_comp_mem
  			 							);

  			 MEM_stage MEM_stage_ins( clk_i,
                                     PC4_mem_i,
  			 						  PC_mem_i,
  			 						  rd_mem_i,
  			 						  alu_out_mem_i,
  			 						  rs2_data_mem_i,
  			 						  csr_data_mem_i,
			                          csr_addr_mem_i,
			                          trap_code_mem_i,
			                          is_trap_mem_i,
			                          is_rs0_mem_i,
			                          //
			                          we_mem_mem,
			                          is_LS_mem,
  		                              funct3_mem_mem,
  		                              data_or_alu_mem,
  		                              //Wishbone
                                      dwbm_ack_i,
                                      dwbm_err_i,
                                      dwbm_dat_i,                                    
                                      //Outputs
                                      PC4_mem_o,   
		                              PC_mem_o,     
		                              rd_mem_o,     
		                              csr_data_mem_o, 
		                              csr_addr_mem_o,    
			                          trap_code_mem_o,   
		                              is_trap_mem_o,     
		                              is_rs0_mem_o,
		                              //Wishbone
		                              dwbm_addr_o,
                                      dwbm_dat_o,
                                      dwbm_sel_o,
                                      dwbm_cyc_o,
                                      dwbm_stb_o,
                                      dwbm_we_o,
                                      //
                                      data_wb_mem,
                                      stall_mem
  			 						  );

  			 reg_mem_wb reg_mem_wb_ins( clk_i,
  			 							rst4,
  			 							is_trap_mem_oo,
  			 							en_stages[0],
  			 							//From MEM
  			 							PC4_mem_o,   
			                            PC_mem_o,     
			                            rd_mem_o,     
			                            csr_data_mem_o, 
			                            csr_addr_mem_o,    
				                        trap_code_mem_oo,   
			                            is_trap_mem_oo,     
			                            is_rs0_mem_o,
			                            data_wb_mem,
			                            //control  		   
  		                                we_wb_mem,
  		                                mux_wb_sel_mem,
  		                                csr_op_mem,
  	                                    comp_mem,
  	                                    is_csr_mem,
  		                                is_mret_mem,
                                        is_FW_mem,
                                        is_comp_mem,
  		                                //To WB
  		                                PC4_wb,   
										PC_wb,     
										rd_wb_i,      
										csr_data_wb,   
										csr_addr_wb,    
										trap_code_wb,    
										is_trap_wb_i,      
										is_rs0_wb,
										data_wb_wb,
										//control
										we_wb_wb_i,
							  		    mux_wb_sel_wb,
							  		    csr_op_wb,
							  	    	comp_wb,
							  		    is_csr_wb,
							  		    is_mret_wb,
                                        is_FW_wb,
                                        is_comp_wb
  			 							);

  			 WB_stage WB_stage_ins ( clk_i,
  			 						 rst_i,
  			 						 //
 									 PC4_wb,   
									 PC_wb,     
									 rd_wb_i,      
									 csr_data_wb,   
									 csr_addr_wb,    
									 trap_code_wb,    
									 is_trap_wb_i,
									 data_wb_wb,
									 we_wb_wb_i,
									 mux_wb_sel_wb,
									 csr_op_wb,
									 comp_wb,
									 is_mret_wb,
									 //interrupts
									 xint_meip_i,
                                     xint_mtip_i,
                                     xint_msip_i,
                                     //
                                     is_csr_wb,
                                     is_rs0_wb,
                                     //outputs
                                     data_from_wb,
                                     rd_wb_o,
                                     we_wb_wb_o,
                                     is_trap_wb_o,
                                     CSR_data_out
                                     );

  			 hazard_unit hazard_unit_ins( rd_ex_i,
  			 							  rd_mem_i,
  			 							  rd_wb_i,
  			 							  instr_id[19:15],
  			 							  instr_id[24:20],
  			 							  instr_id[6:0],
  			 							  opcode_ex,
  			 							  opcode_mem,
  			 							  branch_taken_id,
  			 							  stall_mem,
  			 							  stall_if,
  			 							  is_trap_wb_o,
  			 							  is_mret_wb,
                                          is_FW_ex,
                                          is_FW_mem,
                                          is_FW_wb,
  			 							  //outputs
  			 							  ctrl_forwa,
  			 							  ctrl_forwb,
  			 							  en_stages,
  			 							  rst_stages,
  			 							  IF_en
  			 	                          );
endmodule  
