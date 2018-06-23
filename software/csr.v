
//CSR module for XYZ Processor Core. Author: Jesus Colmenares / 14-11384

module csr(input wire clk_i,
		   input wire rst_i,
		   input wire is_csr,  //flag to CSR
		   input wire is_trap,  //flag to trap
		   input wire [4:0] rd_i,   //destination register
		   input wire is_rs1_i,  //flag for x0  (is_rs1_i=1 if rs1=x0)
		   input wire [31:0] data_i,  //data from rs1
		   input wire [11:0] addr_i, //CSR addr
		   input wire [1:0] op_i,  //determine CSR instruction
		   /* verilator lint_off UNUSED */
		   input wire [31:0] PC_i, //current PC, needed if trap or interrupt
		   input wire [3:0] trap_cause_i, //trap cause code
		   //Interrupts
		   input wire 		 is_interrupt,  //flag for interrupts
		   input wire        int_meip_i,
           input wire        int_mtip_i,
           input wire        int_msip_i,


		   output reg [31:0] data_o,
		   output reg  err_o);

	
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

    //Register File
    reg [31:0] mvendorid = 32'h123; //random value
    reg [31:0] marchid = 32'h456;	//random value
    reg [31:0] mimpid = 32'h678;	//random value
    reg [31:0] mhartid = 32'h912;   //random value
    reg [31:0] misa, medeleg, mideleg, mtvec, mcounteren, mscratch;
    reg [31:0] mepc, mtval, mcycle, minstret, mcycleh, minstreth;
    //Special registers
    wire [31:0] mcause, mie, mip, mstatus;
    //special fields
    reg [1:0]   mstatus_mpp;
    reg         mstatus_mpie, mstatus_mie;
    reg         mie_meie, mie_mtie, mie_msie;
    reg         mcause_interrupt;
    reg [3:0]   mcause_mecode;
    //internal wiring
    wire [31:0] data_write;
    wire [31:0] data_read;
    wire error;
    wire is_write;

    always @(*) begin  //determine if must write based on rs1

    	if ((op_i==2'b10 || op_i==2'b11) && is_rs1_i)   
    		is_write=1'b0;    
    	else 
    		is_write=1'b1;       	
    end

  //assignments to special registers
  	always @(*) begin
  		mip     = {20'b0, int_meip_i, 3'b0, int_mtip_i, 3'b0, int_msip_i, 3'b0};
    	mie     = {20'b0, mie_meie, 3'b0, mie_mtie, 3'b0, mie_msie, 3'b0};
    	mstatus = {19'b0, mstatus_mpp, 3'b0, mstatus_mpie, 3'b0, mstatus_mie, 3'b0};      	
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
		        /* verilator lint_off CASEOVERLAP */
		        MHARTID: data_read = mhartid;
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
		        			error=1;
		        		end
		    endcase
		else 
		    data_read = 32'h0;      
   end   

    //Write a register sequencially on next posedge.
    always @(posedge clk_i) 
        begin
        	if (rst_i) 
                begin
            		data_o <= 32'h0;
                    /* verilator lint_off BLKSEQ */
            		err_o <= 1'h0;
            		
            		misa <= 32'h0;
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
         	  		mstatus_mpp <= 2'b0;
    		        mstatus_mpie <= 1'b0;
    		        mstatus_mie <= 1'b0;
    	            mie_meie <= 1'b0;
    	            mie_mtie <= 1'b0;
    	            mie_msie <= 1'b0;
     	            mcause_interrupt <= 1'b0;
   			        mcause_mecode <= 4'b0;
        	   end

            else 
                begin
                    if (is_trap) //set a trap
                        begin
                            mepc <= {PC_i[31:2], 2'b0};
                            mcause_mecode <= trap_cause_i;
                            data_o <= mtvec;            
                        end

            	    else if  (is_csr & ~err_o & is_write)  //sequencial write to CSR
                        begin
                		  case(addr_i)

                			MSTATUS: begin
	            						mstatus_mpp <= data_write[12:11];
	       								mstatus_mpie <= data_write[7];
	       								mstatus_mie <= data_write[3];
                					end
                			MISA: 	 	misa <= data_write;
                			MEDELEG: 	medeleg <= data_write;
                			MIDELEG: 	mideleg <= data_write;
                			MIE: begin
	                					mie_meie <= data_write[11];
	                					mie_mtie <= data_write[7];
	                					mie_msie <= data_write[3];                				
                				end
                			MTVEC: 		mtvec <= data_write;
                			MCOUNTEREN: mcounteren <= data_write;
                			MSCRATCH: 	mscratch <= data_write;
                			MEPC: 		mepc <= data_write;
                			MCAUSE: begin
                					   mcause_interrupt <= data_write[31];  
                					   mcause_mecode <= data_write[3:0];
                					end
                			MTVAL: 	   mtval <= data_write;                		
                			MCYCLE:    mcycle <= data_write;
                			MINSTRET:  minstret <= data_write;
                			MCYCLEH:   mcycleh <= data_write;
                			MINSTRETH: minstreth <= data_write;
                			default: begin
                                err_o <= 1'b1;
                                mepc <= {PC_i[31:2], 2'b0};
                                mcause_mecode <= trap_cause_i;
                                data_o <= mtvec;   
                                end   		
                		    endcase
                    end
                    if (error) 
                        begin
                            err_o <= 0;
                            mepc <= {PC_i[31:2], 2'b0};
                            mcause_mecode <= trap_cause_i;
                            data_o <= mtvec;   
                        end 
                end
    	end  

    always @(posedge clk_i) begin  //If interrupt, set interrupt bit
    	if (is_interrupt) 
    		mcause_interrupt <= 1'b1;    	
    end 

    //Register 
    always @(posedge clk_i) begin
    	if(is_csr)
    	data_o <= data_read;
    end

    always @(*) begin

        case(op_i)
            2'b01:  data_write = data_i;
            2'b10:  data_write = data_i | data_read;
            2'b11:  data_write = data_i & ~data_read;
            default: begin
                        data_write= 32'h0;
                        if(is_csr) error = 1'b1;
                        else error=1'b0;
                    end
        endcase       
    end   

    endmodule

   

