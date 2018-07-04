  //Reg IF-ID

  module reg_if_id( input wire clk_i,
  					input wire rst_i,
  					input wire clear,
  					input wire en,

  					//From IF
  					input wire [31:0] instr_if,
  					input wire [31:0] PC4_if,
  					input wire [31:0] PC_if,
  					input wire [3:0]  trap_code_if,
  					input wire 		  is_trap_if,
  					//To ID
  					output reg [31:0] instr_id,
  					output reg [31:0] PC4_id,
  					output reg [31:0] PC_id,
  					output reg [3:0]  trap_code_id,
  					output reg 		  is_trap_id
  					);

  	always @(posedge clk_i) begin
  		if (rst_i) begin

  			instr_id <= 32'b0;
  			PC4_id <= 32'b0;
  			PC_id <= 32'b0;
  			trap_code_id <= 4'b0;
  			is_trap_id <= 1'b0;
  			
  		end
  		else if (clear) 
  			instr_id <= 32'b0;  		

  		else begin

  			if(en) begin
  				instr_id <= instr_if ;
  				PC4_id <= PC4_if;
  				PC_id <= PC_if;
  				trap_code_id <= trap_code_if;
  				is_trap_id <= is_trap_if;
  				
  			end
  			else begin
  				instr_id <= instr_id ;
  				PC4_id <= PC4_id;
  				PC_id <= PC_id;
  				trap_code_id <= trap_code_id;
  				is_trap_id <= is_trap_id;
  			end
  			  			
  		end
  	end

  	endmodule



	