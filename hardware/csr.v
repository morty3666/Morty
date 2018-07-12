//CSR module for XYZ Processor Core. Author: Jesus Colmenares / 14-11384

module csr (input wire clk_i,
		   input wire rst_i,
		   input wire is_csr_i,  //flag to CSR    CONTROL SIGNAL
		   input wire is_trap_i,  //flag to trap
		   input wire [4:0] rd_i,   //destination register
		   input wire is_rs1_i,  //flag for x0  (is_rs1_i=1 if rs1=x0)
		   input wire [31:0] data_i,  //data 
		   input wire [11:0] addr_i, //CSR addr
		   input wire [1:0] op_i,  //determine CSR instruction  CONTROL SIGNAL
           input wire [31:0] addr_misa,
		   /* verilator lint_off UNUSED */
		   input wire [31:0] PC_i, //current PC, needed if trap or interrupt
		   input wire [3:0] trap_cause_i, //trap cause code
           input wire       is_mret,  //flag for mret instruction
		   //Interrupts
		   input wire 		 is_interrupt,  //flag for interrupts
		   input wire        int_meip_i,
           input wire        int_mtip_i,
           input wire        int_msip_i,


		   output reg [31:0] data_o,
           output reg [31:0] data_read_o,
		   output reg  err_o
           );

	
	//Implemented registers

    //Machine information 
    localparam MVENDORID  = 12'hF11;
    localparam MARCHID    = 12'hF12;
    localparam MIMPID     = 12'hF13;
    localparam MHARTID    = 12'hF14;
    //Machine Trap Setup
    localparam MSTATUS    = 12'h300;
    localparam MISA       = 12'h301;
    localparam MEDELEG    = 12'h302;
    localparam MIDELEG    = 12'h303;
    localparam MIE        = 12'h304;
    localparam MTVEC      = 12'h305;
    localparam MCOUNTEREN = 12'h306;
    //Machine Trap Handling
    localparam MSCRATCH   = 12'h340;
    localparam MEPC       = 12'h341;
    localparam MCAUSE     = 12'h342;
    localparam MTVAL      = 12'h343;
    localparam MIP        = 12'h344;
    //Machine Counter/Timers
    localparam MCYCLE     = 12'hB00;
    localparam MINSTRET   = 12'hB02;
    localparam MCYCLEH    = 12'hB80;
    localparam MINSTRETH  = 12'hB82;

    //Exception caused by CSR.
    localparam E_ILLEGAL_INST = 4'd2;
    localparam I_M_SOFTWARE   = 4'd3;
    localparam I_M_TIMER      = 4'd7;
    localparam I_M_EXTERNAL   = 4'd11;

    //Register File
    reg [31:0] mvendorid = 32'h0; //random value
    reg [31:0] marchid = 32'h0;	//random value
    reg [31:0] mimpid = 32'h0;	//random value
    reg [31:0] mhartid = 32'h0;   //random value
    reg [31:0] misa, medeleg, mideleg, mtvec, mcounteren, mscratch;
    reg [31:0] mepc, mtval, mcycle, minstret, mcycleh, minstreth;
    //Special registers
    wire [31:0] mcause, mie, mip, mstatus;
    //special fields
   
    reg         mstatus_mie;
    reg         mie_meie, mie_mtie, mie_msie;
    reg         mcause_interrupt;
    reg [3:0]   mcause_mecode;
    //internal wiring
    wire [31:0] data_write;
    wire [31:0] data_read;
    wire error_r;  //error reading
    wire error_c;  //error determining write data.
    reg  error_w;  //error writing
    wire is_write;    
    wire valid_write;

    assign valid_write = ((addr_i==MSTATUS) | (addr_i==MISA) | (addr_i==MEDELEG) | (addr_i==MIDELEG) | (addr_i==MIE) | (addr_i==MTVEC) | (addr_i==MCOUNTEREN) | (addr_i==MSCRATCH) | (addr_i==MEPC) | (addr_i==MCAUSE) | (addr_i==MTVAL) | (addr_i==MCYCLE) | (addr_i==MINSTRET) | (addr_i==MCYCLEH) | (addr_i==MINSTRETH));

    assign data_read_o = data_read;

    always @(*) begin  //determine if must write based on rs1

    	if ((op_i==2'b10 | op_i==2'b11) & is_rs1_i)   
    		is_write=1'b0;    
    	else 
    		is_write=1'b1;       	
    end


  //assignments to special registers
  	always @(*) begin
  		mip     = {20'b0, int_meip_i, 3'b0, int_mtip_i, 3'b0, int_msip_i, 3'b0};
    	mie     = {20'b0, mie_meie, 3'b0, mie_mtie, 3'b0, mie_msie, 3'b0};
    	mstatus = {28'b0, mstatus_mie, 3'b0};      	
    	mcause  = {mcause_interrupt, 27'b0, mcause_mecode};  		
  	end
 	

   //Read a register combinationally
   always @(*) begin
   		if(!(rd_i==5'b0 & op_i==2'b00))  //reads only if it is not CSRRW inst with rd=x0.
		    case(addr_i) 
		        MVENDORID: data_read = mvendorid;
		        MARCHID:  data_read = marchid;
		        MHARTID: data_read = mhartid;
		        MIMPID:  data_read = mimpid;
		        MSTATUS: data_read = mstatus;
		        MISA: data_read = misa;
		        MEDELEG: data_read = medeleg;
		        MIDELEG: data_read = mideleg;
		        MIE: data_read = mie;
		        MTVEC: data_read = mtvec;
		        MCOUNTEREN: data_read = mcounteren;
		        MSCRATCH: data_read = mscratch;
		        MEPC: data_read = mepc;
		        MCAUSE: data_read = mcause;
		        MTVAL: data_read = mtval;
		        MIP: data_read = mip;
		        MCYCLE: data_read = mcycle;
		        MINSTRET: data_read = minstret;
		        MCYCLEH: data_read = mcycleh;
		        MINSTRETH: data_read = minstreth;
		        default: begin 
		        			data_read = 32'h0;
                            if(is_csr_i)
		        			   error_r=1;   //ARREGLAR
                            else
                               error_r=0;
		        		end
		    endcase
		else 
		    data_read = 32'h0;
            error_r=0;      
   end   

    //Write a register sequencially on next posedge.
    always @(posedge clk_i) 
        begin
        	if (rst_i) 
                begin
            		data_o <= 32'h0;                    
            		error_w <= 1'h0;            		
            		misa <= {2'b01, 30'b0};
            		medeleg <= 32'h0;
            		mideleg <= 32'h0;            		
            		mtvec <= 32'h0;
            		mcounteren <= 32'h0;
           			mscratch <= 32'h0;
           			mepc <= 32'h0;           			
           			mtval <= 32'h0;           			
           			mcycle <= 32'h0;
           			minstret <= 32'h0;
           			mcycleh <= 32'h0;
           			minstreth <= 32'h0;
           			//Special fields
         	  	    mstatus_mie <= 1'b0;
    	            mie_meie <= 1'b0;
    	            mie_mtie <= 1'b0;
    	            mie_msie <= 1'b0;
     	            mcause_interrupt <= 1'b0;
   			        mcause_mecode <= 4'b0;
        	   end

            else 
                begin
                    
                    if(is_csr_i & is_mret)
                            data_o <= mepc;                        
                    

            	    else if  (is_csr_i & is_write)  //sequencial write to CSR
                        begin
                		  case(addr_i)                          

                			MSTATUS: begin
	            						mstatus_mie <= data_write[3];
                                        data_o <= data_read;
                                        error_w <= 1'b0;
                					end
                			MISA: 	 	begin
                                            misa <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MEDELEG: 	begin
                                            medeleg <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MIDELEG: 	begin
                                            mideleg <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MIE: begin
	                					mie_meie <= data_write[11];
	                					mie_mtie <= data_write[7];
	                					mie_msie <= data_write[3];
                                        data_o <= data_read;
                                        error_w <= 1'b0;                				
                				end
                			MTVEC: 		begin
                                            mtvec <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MCOUNTEREN: begin
                                            mcounteren <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MSCRATCH: 	begin
                                            mscratch <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MEPC: 		begin
                                            mepc <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MCAUSE: begin
                					   mcause_interrupt <= data_write[31];  
                					   mcause_mecode <= data_write[3:0];
                                       data_o <= data_read;
                                       error_w <= 1'b0;
                					end
                			MTVAL: 	   begin
                                            mtval <= data_write;
                                            data_o <= data_read; 
                                            error_w <= 1'b0;
                                        end               		
                			MCYCLE:    begin
                                            mcycle <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MINSTRET:  begin
                                            minstret <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MCYCLEH:   begin
                                            mcycleh <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			MINSTRETH: begin
                                            minstreth <= data_write;
                                            data_o <= data_read;
                                            error_w <= 1'b0;
                                        end
                			default: begin                                
                                mepc <= {PC_i[31:2], 2'b0};
                                mcause_mecode <= E_ILLEGAL_INST;
                                data_o <= mtvec;                                                                  
                                end   		
                		    endcase                        
                    end

                    else if (is_trap_i | error_r | error_c| (is_interrupt & mstatus_mie)) //set a trap
                        begin

                            if(error_r | error_c)
                                mcause_mecode <= E_ILLEGAL_INST;

                            else if(is_interrupt & mstatus_mie) begin                                
                            
                               mcause_interrupt <= 1'b1;

                               if(mie_msie & int_msip_i)                               
                                    mcause_mecode <= I_M_SOFTWARE;

                                else if(mie_mtie & int_mtip_i)
                                    mcause_mecode <= I_M_TIMER;

                                else if(mie_meie & int_meip_i)
                                    mcause_mecode <= I_M_EXTERNAL; 
                                else
                                    mcause_mecode <= 4'b0; 

                            end                           
                            
                            else                             
                                mcause_mecode <= trap_cause_i;                                                                      
                                                        
                                mepc <= {PC_i[31:2], 2'b0};
                                data_o <= mtvec;

                                 if(trap_cause_i==4'd4 | trap_cause_i==4'd6) 
                                    mtval <= addr_misa;
                                 else if(trap_cause_i==4'b0)
                                 	mtval <= PC_i;
                                else
                                    mtval <= 32'b0;                           
                                                                   
                        end
                    else begin
                        data_o <= data_read;                        
                        end                                       
                                                       
                end
    	end 

        //Set flag error.
    always @(*) begin

        if(error_r | error_c | (~valid_write & is_write & is_csr_i))
            err_o=1'b1;
        else 
            err_o=1'b0;        
    end

    
    always @(*) begin

        case(op_i)
            2'b01:  data_write = data_i;
            2'b10:  data_write = data_i | data_read;
            2'b11:  data_write = ~data_i & data_read;
            default: begin
                        data_write= 32'h0;
                        if(is_csr_i) error_c = 1'b1;
                        else error_c=1'b0;
                    end
        endcase       
    end   

    endmodule
