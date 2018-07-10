//LSU  Author: Jesús Colmenares / 14-11384

module LSU( input wire clk_i,
			input wire is_LS_i,
			input wire [2:0] funct3_i,
			input wire [1:0] addr_i,
			//Wishbone signals
			input wire        wbm_ack_i,  
            input wire        wbm_err_i,                 
	        output reg [ 3:0] wbm_sel_o,
	        output reg        wbm_cyc_o,
	        output reg        wbm_stb_o,	        
	        //-------------------------
            output reg		   stall_o  //Stop datapath for stall_o=1
            );



	//Type of stores
	localparam SB=3'b000;
	localparam SH=3'b001;
	localparam SW=3'b010;


	always @(posedge clk_i) begin

		if(is_LS_i) begin

				if (wbm_ack_i | wbm_err_i)  begin

					wbm_stb_o<=1'b0;
					wbm_cyc_o<=1'b0;						
					wbm_sel_o<=4'b0;					
				end
				else begin
					wbm_stb_o<=1'b1;
					wbm_cyc_o<=1'b1;
					

					case(funct3_i)

						SB: begin
							case(addr_i)
								2'b00: wbm_sel_o<=4'b0001;
								2'b01: wbm_sel_o<=4'b0010;
								2'b10: wbm_sel_o<=4'b0100;
								2'b11: wbm_sel_o<=4'b1000;
							endcase						
						end
						SH: begin
							case(addr_i[1])
								1'b0: wbm_sel_o<=4'b0011;
								1'b1: wbm_sel_o<=4'b1100;								
							endcase							
						end
						SW: wbm_sel_o<=4'b1111;
						default: wbm_sel_o<=4'b0;
					endcase		
				end
		end
		else begin
			wbm_stb_o<=1'b0;
			wbm_cyc_o<=1'b0;
			wbm_sel_o<=4'b0;			
			

		end		
	end

	//Stall if LS instruction
	always @(*) begin
		if(is_LS_i & ~wbm_ack_i)
			stall_o=1'b1;
		else 
			stall_o=1'b0;		
		
	end

endmodule


            
             








	
