//Writeback stage XYZ Processor core

`include "csr.v"

module WB_stage(
				input wire rst_i,
				input wire clk_i,
				//From MEM
				input wire [31:0] PC4_wb_i,     
				input wire [31:0] PC_wb_i,   
				input wire [4:0] rd_wb_i,      
				input wire [31:0] csr_data_wb_i,  
				input wire [11:0] csr_addr_wb_i,   
				input wire [3:0] trap_code_wb_i,    
				input wire		  is_trap_wb_i,
				input wire [31:0] data_or_alu_i,  //data to WB.
				input wire rf_we_wb_i, //Control signal
				input wire [1:0] mux_sel_i,  //Control signal
				input wire [1:0] csr_op_i,	//Control signal
				input wire comp_i, //control signal, used by WB for inst STL			
				//interrupts ports
				input wire        int_meip_wb_i,
           		input wire        int_mtip_wb_i,
           		input wire        int_msip_wb_i,
				//Aditional CSR inputs
				input wire is_csr_wb_i,   //Control signal
				input wire is_rs1_wb_i, //1 if rs1==0
				//Outputs
				output reg [31:0] writeback_data_o,
				output reg [4:0] rd_wb_o,
				output reg	rf_we_wb_o,
				output reg  is_trap_wb_o  //Signal to hazard unit.
				);


	
		wire [31:0] CSR_data_out;
		wire csr_err;
		wire is_interrupt;

		assign is_interrupt = (int_meip_wb_i | int_msip_wb_i | int_mtip_wb_i);

		always @(*) begin
			//set signal for hazard unit
			if(is_trap_wb_i | csr_err)
				is_trap_wb_o=1'b1;  
			else
				is_trap_wb_o=1'b0;

			//Select WB data
			if(is_trap_wb_i)
				writeback_data_o=CSR_data_out;
			else begin
				
				case(mux_sel_i)
					2'b00: writeback_data_o=data_or_alu_i;
					2'b01: writeback_data_o=PC4_wb_i;
					2'b10: writeback_data_o=CSR_data_out;
					2'b11: writeback_data_o={31'b0, comp_i};
				endcase	
			end

			//Propagate WE to RF
			rf_we_wb_o=rf_we_wb_i;
			rd_wb_o=rd_wb_i;		
		end

		//Implementing CSR
	csr csr_ins(clk_i,rst_i,is_csr_wb_i,is_trap_wb_i,rd_wb_i,is_rs1_wb_i,csr_data_wb_i,csr_addr_wb_i,csr_op_i,PC_wb_i,trap_code_wb_i,is_interrupt,
		int_meip_wb_i,int_mtip_wb_i,int_msip_wb_i,CSR_data_out,csr_err);

	endmodule


	
