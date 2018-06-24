//LSU  Author: Jesús Colmenares / 14-11384

module LSU( input wire is_LS_i,
			input wire [2:0] funct3_i,
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


	always @(*) begin

		if(is_LS_i) begin

				if (wbm_ack_i | wbm_err_i)  begin

					wbm_stb_o=1'b0;
					wbm_cyc_o=1'b0;				
					stall_o=1'b0;
					wbm_sel_o=4'b0;
					
				end

				else begin

					wbm_stb_o=1'b1;
					wbm_cyc_o=1'b1;				
					stall_o=1'b1;

					case(funct3_i)

						SB: wbm_sel_o=4'b0001;
						SH: wbm_sel_o=4'b0011;
						SW: wbm_sel_o=4'b1111;
						default: wbm_sel_o=4'b0;

					endcase					

				end

		end

		else begin
			wbm_stb_o=1'b0;
			wbm_cyc_o=1'b0;
			wbm_sel_o=4'b0;			
			stall_o=1'b0;

		end

		
	end

endmodule



            
             








	