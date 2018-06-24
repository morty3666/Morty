//XYZ PROCESSOR CORE
//AUTHOR: JESUS COLMENARES  
//HAZARD UNIT

module hazard_unit(//inputs
				   input wire [4:0] rd_ex_i,  
				   input wire [4:0] rd_mem_i,
				   input wire [4:0] rd_wb_i,
				   input wire [4:0] rs1_id_i,
				   input wire [4:0] rs2_id_i,
				   input wire [6:0] opcode_id_i,
				   input wire [6:0] opcode_ex_i,
				   input wire [6:0] opcode_mem_i,
				   input wire is_branch,
				   input wire is_MEM, //Flag for LS instruction in process in MEM stage
				   input wire is_IF, //Flag for instruction being fetched
				   input wire is_trap, //Flag for any kind of exception
				   //Outputs
				   output reg [1:0] FW1_o,  //FW to rs1
				   output reg [1:0] FW2_o, //FW to rs2
				   output reg [3:0] en_o,  //Enable for registers between stages
				   output reg [3:0] clear_o, //Reset for registers between stages 
				   output reg pc_en_o  //PC enable
				   );


	localparam load = 7'b0000011;
	localparam CSR =  7'b1110011;	
	localparam JAL =  7'b1101111;
	localparam JALR =  7'b1100111;
	localparam branch =  7'b1100011;

	//FORWARDING
	// RF= 00
	// EX = 01
	// MEM = 10
	//  WB = 11
	always @(*) begin
						//Forwarding for rs1
						if(rd_ex_i!=0 & (rs1_id_i==rd_ex_i) )
							FW1_o= 2'b01;

						else if(rd_mem_i!=0 & (rs1_id_i==rd_mem_i) )
							FW1_o= 2'b10;

						else if(rd_wb_i!=0 & (rs1_id_i==rd_wb_i) )
							FW1_o= 2'b11;

						else 
							FW1_o=2'b00;	

						//Forwarding for rs2
						if(rd_ex_i!=0 & (rs2_id_i==rd_ex_i) )
							FW2_o= 2'b01;

						else if(rd_mem_i!=0 & (rs2_id_i==rd_mem_i) )
							FW2_o= 2'b10;

						else if(rd_wb_i!=0 & (rs2_id_i==rd_wb_i) )
							FW2_o= 2'b11;

						else 
							FW2_o=2'b00;
				end

	//en= 1  reg activated
	//en= 0 reg desactivated
	//clear = 1   reset register
	//clear=0   nothing happens.

		//Stalls
		always @(*) begin

						if(is_trap) begin  //An exception happens
							en_o= 4'b1111;
							clear_o= 4'b1111;
							pc_en_o=1'b1;
						end								

						else if(is_MEM) begin //MEM stage processing a LS instruction
							en_o= 4'b0001;
							clear_o= 4'b0001;
							pc_en_o=1'b0;
						end

						else if((opcode_ex_i== load | opcode_ex_i== CSR) & (rd_ex_i!=0 & (rs1_id_i==rd_ex_i | rs2_id_i==rd_ex_i ))) begin //load or CSR instruction
							en_o= 4'b0111;
							clear_o= 4'b0100;
							pc_en_o=1'b0;
						end

						else if(opcode_mem_i== CSR & (rd_mem_i!=0 & (rs1_id_i==rd_mem_i | rs2_id_i==rd_mem_i ))) begin //CSR instruction
							en_o= 4'b0111;
							clear_o= 4'b0100;
							pc_en_o=1'b0;
						end

						else if(opcode_id_i== JAL | opcode_id_i== JALR) begin //J instruction
							en_o= 4'b1111;
							clear_o= 4'b1000;
							pc_en_o=1'b1;
						end

						else if(opcode_id_i== branch & is_branch) begin //branch instruction
							en_o= 4'b1111;
							clear_o= 4'b1000;
							pc_en_o=1'b1;
						end

						else if(is_IF) begin   //Instruction being fetched
							en_o= 4'b1111;
							clear_o= 4'b1000;
							pc_en_o=1'b1;							

						end
						
						else begin
							en_o= 4'b1111;
							clear_o= 4'b0000;
							pc_en_o=1'b1;
							end
					end
endmodule
