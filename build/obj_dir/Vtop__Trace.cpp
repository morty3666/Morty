// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


//======================

void Vtop::traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vtop* t=(Vtop*)userthis;
    Vtop__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (vlSymsp->getClearActivity()) {
	t->traceChgThis(vlSymsp, vcdp, code);
    }
}

//======================


void Vtop::traceChgThis(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 1U))))) {
	    vlTOPp->traceChgThis__2(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & ((vlTOPp->__Vm_traceActivity 
				| (vlTOPp->__Vm_traceActivity 
				   >> 1U)) | (vlTOPp->__Vm_traceActivity 
					      >> 2U))))) {
	    vlTOPp->traceChgThis__3(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 2U))))) {
	    vlTOPp->traceChgThis__4(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((2U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__5(vlSymsp, vcdp, code);
	}
	vlTOPp->traceChgThis__6(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void Vtop::traceChgThis__2(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1,(vlTOPp->top__DOT__dwbm_dat_i),32);
	vcdp->chgBus  (c+2,(vlTOPp->top__DOT__iwbm_dat),32);
	vcdp->chgBit  (c+3,(vlTOPp->top__DOT__iwbm_ack));
	vcdp->chgBit  (c+4,(vlTOPp->top__DOT__dwbm_ack));
	vcdp->chgBit  (c+5,(vlTOPp->top__DOT__cpu__DOT__id_stall));
	vcdp->chgBus  (c+6,(vlTOPp->top__DOT__cpu__DOT__EX__DOT__ex_result),32);
	vcdp->chgBus  (c+7,(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_result),32);
	vcdp->chgBus  (c+8,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__rs1),5);
	vcdp->chgBus  (c+9,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__rs2),5);
	vcdp->chgBit  (c+10,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_j));
	vcdp->chgBit  (c+11,(vlTOPp->top__DOT__cpu__DOT__mem_stall_req));
	vcdp->chgBit  (c+12,(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_trap_valid));
	vcdp->chgBus  (c+13,(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_exception),4);
	vcdp->chgBus  (c+14,(vlTOPp->top__DOT__cpu__DOT__mem_load_data),32);
	vcdp->chgBus  (c+15,(vlTOPp->top__DOT__cpu__DOT__wb_result),32);
	vcdp->chgBit  (c+16,(vlTOPp->top__DOT__cpu__DOT__ex_nop));
	vcdp->chgBit  (c+17,(vlTOPp->top__DOT__cpu__DOT__hazard));
	vcdp->chgBit  (c+18,(vlTOPp->top__DOT__cpu__DOT__HZ__DOT__csr));
	vcdp->chgBit  (c+19,(vlTOPp->top__DOT__cpu__DOT__HZ__DOT__ld));
	vcdp->chgBus  (c+20,(vlTOPp->top__DOT__cpu__DOT__exception_pc),32);
	vcdp->chgBit  (c+21,(vlTOPp->top__DOT__cpu__DOT__exception_stall_req));
	vcdp->chgBus  (c+22,(vlTOPp->top__DOT__cpu__DOT__csr_data_o),32);
	vcdp->chgBus  (c+23,(((0U == (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__rs1))
			       ? 0U : vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file
			      [vlTOPp->top__DOT__cpu__DOT__ID__DOT__rs1])),32);
	vcdp->chgBus  (c+24,(((0U == (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__rs2))
			       ? 0U : vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file
			      [vlTOPp->top__DOT__cpu__DOT__ID__DOT__rs2])),32);
	vcdp->chgBit  (c+25,(((0U != (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__waddr)) 
			      & (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_wr))));
	vcdp->chgBus  (c+26,((((((((((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_add) 
				     | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sub)) 
				    | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_and)) 
				   | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_or)) 
				  | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_xor)) 
				 | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sll)) 
				| (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sr)) 
			       | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_slt))
			       ? ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_add)
				   ? 0U : ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sub)
					    ? 1U : 
					   ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_and)
					     ? 2U : 
					    ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_or)
					      ? 3U : 
					     ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_xor)
					       ? 4U
					       : ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sll)
						   ? 5U
						   : 
						  ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sr)
						    ? 
						   (((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sra) 
						     | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__srai))
						     ? 6U
						     : 7U)
						    : 8U)))))))
			       : ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sltu)
				   ? 9U : 0xfU))),4);
	vcdp->chgBus  (c+27,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__comparator_op),3);
	vcdp->chgBus  (c+28,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__imm),32);
	vcdp->chgBus  (c+29,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__waddr),5);
	vcdp->chgBit  (c+30,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_immop));
	vcdp->chgBit  (c+31,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__porta_sel));
	vcdp->chgBit  (c+32,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__jalr));
	vcdp->chgBus  (c+33,((((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_st) 
			       << 5U) | (((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_ld) 
					  << 4U) | 
					 (((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_word) 
					   << 3U) | 
					  (((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_hw) 
					    << 2U) 
					   | (((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_byte) 
					       << 1U) 
					      | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_ldu))))))),6);
	vcdp->chgBit  (c+34,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_ld));
	vcdp->chgBit  (c+35,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_b));
	vcdp->chgBit  (c+36,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT___break));
	vcdp->chgBit  (c+37,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__call));
	vcdp->chgBus  (c+38,(((((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rc) 
				| (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rci)) 
			       << 2U) | ((((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rs) 
					   | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rsi)) 
					  << 1U) | 
					 ((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rw) 
					  | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rwi))))),3);
	vcdp->chgBit  (c+39,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_csri));
	vcdp->chgBit  (c+40,(((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__fence) 
			      & (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__fencei))));
	vcdp->chgBit  (c+41,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__xret));
	vcdp->chgBit  (c+42,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__illegal));
	vcdp->chgBit  (c+43,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_shift));
	vcdp->chgBus  (c+44,(((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_j)
			       ? ((IData)(4U) + vlTOPp->top__DOT__cpu__DOT__id_pc)
			       : vlTOPp->top__DOT__cpu__DOT__id_pc)),32);
	vcdp->chgBus  (c+45,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[0]),32);
	vcdp->chgBus  (c+46,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[1]),32);
	vcdp->chgBus  (c+47,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[2]),32);
	vcdp->chgBus  (c+48,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[3]),32);
	vcdp->chgBus  (c+49,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[4]),32);
	vcdp->chgBus  (c+50,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[5]),32);
	vcdp->chgBus  (c+51,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[6]),32);
	vcdp->chgBus  (c+52,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[7]),32);
	vcdp->chgBus  (c+53,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[8]),32);
	vcdp->chgBus  (c+54,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[9]),32);
	vcdp->chgBus  (c+55,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[10]),32);
	vcdp->chgBus  (c+56,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[11]),32);
	vcdp->chgBus  (c+57,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[12]),32);
	vcdp->chgBus  (c+58,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[13]),32);
	vcdp->chgBus  (c+59,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[14]),32);
	vcdp->chgBus  (c+60,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[15]),32);
	vcdp->chgBus  (c+61,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[16]),32);
	vcdp->chgBus  (c+62,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[17]),32);
	vcdp->chgBus  (c+63,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[18]),32);
	vcdp->chgBus  (c+64,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[19]),32);
	vcdp->chgBus  (c+65,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[20]),32);
	vcdp->chgBus  (c+66,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[21]),32);
	vcdp->chgBus  (c+67,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[22]),32);
	vcdp->chgBus  (c+68,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[23]),32);
	vcdp->chgBus  (c+69,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[24]),32);
	vcdp->chgBus  (c+70,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[25]),32);
	vcdp->chgBus  (c+71,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[26]),32);
	vcdp->chgBus  (c+72,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[27]),32);
	vcdp->chgBus  (c+73,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[28]),32);
	vcdp->chgBus  (c+74,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[29]),32);
	vcdp->chgBus  (c+75,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[30]),32);
	vcdp->chgBus  (c+76,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[31]),32);
	vcdp->chgBus  (c+77,((((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_word) 
			       << 2U) | (((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_hw) 
					  << 1U) | (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_byte)))),3);
	vcdp->chgBit  (c+78,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_st));
	vcdp->chgBit  (c+79,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_ldu));
	vcdp->chgBit  (c+80,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lui));
	vcdp->chgBit  (c+81,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__auipc));
	vcdp->chgBit  (c+82,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__jal));
	vcdp->chgBit  (c+83,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__beq));
	vcdp->chgBit  (c+84,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__bne));
	vcdp->chgBit  (c+85,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__blt));
	vcdp->chgBit  (c+86,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__bge));
	vcdp->chgBit  (c+87,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__bltu));
	vcdp->chgBit  (c+88,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__bgeu));
	vcdp->chgBit  (c+89,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lb));
	vcdp->chgBit  (c+90,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lh));
	vcdp->chgBit  (c+91,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lw));
	vcdp->chgBit  (c+92,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lbu));
	vcdp->chgBit  (c+93,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lhu));
	vcdp->chgBit  (c+94,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sb));
	vcdp->chgBit  (c+95,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sh));
	vcdp->chgBit  (c+96,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sw));
	vcdp->chgBit  (c+97,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__addi));
	vcdp->chgBit  (c+98,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__slti));
	vcdp->chgBit  (c+99,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sltiu));
	vcdp->chgBit  (c+100,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__xori));
	vcdp->chgBit  (c+101,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__ori));
	vcdp->chgBit  (c+102,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__andi));
	vcdp->chgBit  (c+103,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__slli));
	vcdp->chgBit  (c+104,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__srli));
	vcdp->chgBit  (c+105,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__srai));
	vcdp->chgBit  (c+106,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__add));
	vcdp->chgBit  (c+107,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sub));
	vcdp->chgBit  (c+108,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sll));
	vcdp->chgBit  (c+109,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__slt));
	vcdp->chgBit  (c+110,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sltu));
	vcdp->chgBit  (c+111,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__srl));
	vcdp->chgBit  (c+112,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sra));
	vcdp->chgBit  (c+113,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__fence));
	vcdp->chgBit  (c+114,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__fencei));
	vcdp->chgBit  (c+115,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rw));
	vcdp->chgBit  (c+116,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rs));
	vcdp->chgBit  (c+117,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rc));
	vcdp->chgBit  (c+118,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rwi));
	vcdp->chgBit  (c+119,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rsi));
	vcdp->chgBit  (c+120,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rci));
	vcdp->chgBit  (c+121,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_imm));
	vcdp->chgBit  (c+122,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_add));
	vcdp->chgBit  (c+123,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sub));
	vcdp->chgBit  (c+124,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_and));
	vcdp->chgBit  (c+125,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_xor));
	vcdp->chgBit  (c+126,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_or));
	vcdp->chgBit  (c+127,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sll));
	vcdp->chgBit  (c+128,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sr));
	vcdp->chgBit  (c+129,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_slt));
	vcdp->chgBit  (c+130,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sltu));
	vcdp->chgBit  (c+131,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_wr));
	vcdp->chgBit  (c+132,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_alu));
	vcdp->chgBit  (c+133,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_immop));
	vcdp->chgBit  (c+134,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_csr));
	vcdp->chgBit  (c+135,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_fence));
	vcdp->chgBit  (c+136,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_word));
	vcdp->chgBit  (c+137,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_byte));
	vcdp->chgBit  (c+138,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_hw));
	vcdp->chgBit  (c+139,(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__ld_misaligned));
	vcdp->chgBit  (c+140,(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__st_misaligned));
	vcdp->chgBus  (c+141,(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_exc_data),32);
	vcdp->chgBit  (c+142,(vlTOPp->top__DOT__cpu__DOT__FWD__DOT__ex_fwd_a));
	vcdp->chgBit  (c+143,(vlTOPp->top__DOT__cpu__DOT__FWD__DOT__ex_fwd_b));
	vcdp->chgBit  (c+144,(vlTOPp->top__DOT__cpu__DOT__FWD__DOT__mem_fwd_a));
	vcdp->chgBit  (c+145,(vlTOPp->top__DOT__cpu__DOT__FWD__DOT__mem_fwd_b));
	vcdp->chgBit  (c+146,(vlTOPp->top__DOT__cpu__DOT__FWD__DOT__wb_fwd_a));
	vcdp->chgBit  (c+147,(vlTOPp->top__DOT__cpu__DOT__FWD__DOT__wb_fwd_b));
	vcdp->chgBit  (c+148,(vlTOPp->top__DOT__cpu__DOT____Vcellinp__LSU__mwrite_i));
	vcdp->chgBus  (c+149,(vlTOPp->top__DOT__cpu__DOT__LSU__DOT__wdata),32);
	vcdp->chgBus  (c+150,(vlTOPp->top__DOT__cpu__DOT__LSU__DOT__wsel_o),4);
	vcdp->chgBus  (c+151,(vlTOPp->top__DOT__cpu__DOT__LSU__DOT__rsel_o),4);
	vcdp->chgBit  (c+152,(vlTOPp->top__DOT__cpu__DOT__LSU__DOT__runsigned));
	vcdp->chgBit  (c+153,(((2U == (IData)(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_exception)) 
			       & (IData)(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_trap_valid))));
	vcdp->chgBit  (c+154,(((0xbU == (IData)(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_exception)) 
			       | ((3U == (IData)(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_exception)) 
				  & (IData)(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_trap_valid)))));
	vcdp->chgBus  (c+155,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__csr_wdata),32);
	vcdp->chgBus  (c+156,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__icode),4);
	vcdp->chgBus  (c+157,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__pend_int),32);
	vcdp->chgBit  (c+158,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__interrupt));
    }
}

void Vtop::traceChgThis__3(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+159,((((IData)(vlTOPp->top__DOT__cpu__DOT__if_stall_req) 
				| (IData)(vlTOPp->top__DOT__cpu__DOT__id_stall)) 
			       | (IData)(vlTOPp->top__DOT__cpu__DOT__HZ__DOT__ld))));
	vcdp->chgBit  (c+160,(((((2U == (IData)(vlTOPp->top__DOT__cpu__DOT__id_exception)) 
				 & (IData)(vlTOPp->top__DOT__cpu__DOT__id_trap_valid)) 
				| ((2U == (IData)(vlTOPp->top__DOT__cpu__DOT__ex_exception)) 
				   & (IData)(vlTOPp->top__DOT__cpu__DOT__ex_trap_valid))) 
			       | ((2U == (IData)(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_exception)) 
				  & (IData)(vlTOPp->top__DOT__cpu__DOT__MEM__DOT__mem_trap_valid)))));
	vcdp->chgBit  (c+161,((((((IData)(vlTOPp->top__DOT__cpu__DOT__if_stall_req) 
				  | (IData)(vlTOPp->top__DOT__cpu__DOT__id_stall)) 
				 | (IData)(vlTOPp->top__DOT__cpu__DOT__HZ__DOT__ld)) 
				& (~ (IData)(vlTOPp->top__DOT__cpu__DOT__if_kill))) 
			       & (~ (IData)(vlTOPp->top__DOT__cpu__DOT__wb_trap_valid)))));
	vcdp->chgBus  (c+162,(((2U & (IData)(vlTOPp->top__DOT__cpu__DOT__if_pc_sel))
			        ? ((1U & (IData)(vlTOPp->top__DOT__cpu__DOT__if_pc_sel))
				    ? vlTOPp->top__DOT__cpu__DOT__exception_pc
				    : (0xfffffffeU 
				       & vlTOPp->top__DOT__cpu__DOT__ID__DOT__pc_jump))
			        : ((1U & (IData)(vlTOPp->top__DOT__cpu__DOT__if_pc_sel))
				    ? vlTOPp->top__DOT__cpu__DOT__pc_branch_addr
				    : ((IData)(4U) 
				       + vlTOPp->top__DOT__cpu__DOT__if_pc)))),32);
	vcdp->chgBus  (c+163,(((IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_csri)
			        ? (IData)(vlTOPp->top__DOT__cpu__DOT__ID__DOT__rs1)
			        : vlTOPp->top__DOT__cpu__DOT__ID__DOT__port_a)),32);
    }
}

void Vtop::traceChgThis__4(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+164,(vlTOPp->top__DOT__cpu__DOT__if_pc_sel),2);
	vcdp->chgBit  (c+165,(vlTOPp->top__DOT__cpu__DOT__id_flush));
	vcdp->chgBus  (c+166,(vlTOPp->top__DOT__cpu__DOT__forward_a_sel),2);
	vcdp->chgBus  (c+167,(vlTOPp->top__DOT__cpu__DOT__forward_b_sel),2);
	vcdp->chgBit  (c+168,(vlTOPp->top__DOT__cpu__DOT__id_trap_valid));
	vcdp->chgBus  (c+169,(vlTOPp->top__DOT__cpu__DOT__id_exception),4);
	vcdp->chgBus  (c+170,((0xfffffffeU & vlTOPp->top__DOT__cpu__DOT__ID__DOT__pc_jump)),32);
	vcdp->chgBus  (c+171,(vlTOPp->top__DOT__cpu__DOT__pc_branch_addr),32);
	vcdp->chgBit  (c+172,(vlTOPp->top__DOT__cpu__DOT__take_branch));
	vcdp->chgBit  (c+173,(vlTOPp->top__DOT__cpu__DOT__mem_flush));
	vcdp->chgBit  (c+174,(vlTOPp->top__DOT__cpu__DOT__wb_flush));
	vcdp->chgBit  (c+175,(vlTOPp->top__DOT__cpu__DOT__if_stall_req));
	vcdp->chgBit  (c+176,(vlTOPp->top__DOT__cpu__DOT__if_kill));
	vcdp->chgBit  (c+177,(vlTOPp->top__DOT__cpu__DOT__en_fwd));
	vcdp->chgBit  (c+178,(vlTOPp->top__DOT__cpu__DOT__HZ__DOT__xcall_break));
	vcdp->chgBit  (c+179,(vlTOPp->top__DOT__cpu__DOT____Vcellinp__ID__ex_flush_i));
	vcdp->chgBus  (c+180,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__muxa_i),32);
	vcdp->chgBus  (c+181,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__muxb_i),32);
	vcdp->chgBus  (c+182,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__port_a),32);
	vcdp->chgBus  (c+183,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__port_b),32);
	vcdp->chgBus  (c+184,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__pc_jump),32);
	vcdp->chgBit  (c+185,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__take_branch));
	vcdp->chgBit  (c+186,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__pc_jexc));
	vcdp->chgBit  (c+187,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__pc_bexc));
	vcdp->chgBus  (c+188,(vlTOPp->top__DOT__cpu__DOT__ID__DOT__id_exc_data),32);
	vcdp->chgBus  (c+189,(vlTOPp->top__DOT__cpu__DOT__ID__DOT___port_b),32);
	vcdp->chgBus  (c+190,((0x1fU & vlTOPp->top__DOT__cpu__DOT__ID__DOT___port_b)),32);
	vcdp->chgBit  (c+191,(((2U == (IData)(vlTOPp->top__DOT__cpu__DOT__id_exception)) 
			       & (IData)(vlTOPp->top__DOT__cpu__DOT__id_trap_valid))));
	vcdp->chgBit  (c+192,(((0xbU == (IData)(vlTOPp->top__DOT__cpu__DOT__id_exception)) 
			       | ((3U == (IData)(vlTOPp->top__DOT__cpu__DOT__id_exception)) 
				  & (IData)(vlTOPp->top__DOT__cpu__DOT__id_trap_valid)))));
    }
}

void Vtop::traceChgThis__5(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+193,(vlTOPp->top__DOT__cpu__DOT__mem_result),32);
	vcdp->chgBit  (c+194,(vlTOPp->top__DOT__dwbm_cyc));
	vcdp->chgBus  (c+195,(vlTOPp->top__DOT__dwbm_dat_o),32);
	vcdp->chgBus  (c+196,(vlTOPp->top__DOT__dwbm_sel),4);
	vcdp->chgBit  (c+197,(vlTOPp->top__DOT__dwbm_stb));
	vcdp->chgBit  (c+198,(vlTOPp->top__DOT__dwbm_we));
	vcdp->chgBus  (c+199,(vlTOPp->top__DOT__cpu__DOT__if_pc),32);
	vcdp->chgBit  (c+200,(vlTOPp->top__DOT__iwbm_cyc));
	vcdp->chgBit  (c+201,(vlTOPp->top__DOT__iwbm_stb));
	vcdp->chgBit  (c+202,(vlTOPp->top__DOT__cpu__DOT__if_trap_valid));
	vcdp->chgBus  (c+203,(vlTOPp->top__DOT__cpu__DOT__if_exception),4);
	vcdp->chgBus  (c+204,(vlTOPp->top__DOT__cpu__DOT__if_exc_data),32);
	vcdp->chgBus  (c+205,(vlTOPp->top__DOT__cpu__DOT__id_instruction),32);
	vcdp->chgBus  (c+206,(vlTOPp->top__DOT__cpu__DOT__id_pc),32);
	vcdp->chgBus  (c+207,(vlTOPp->top__DOT__cpu__DOT__wb_waddr),5);
	vcdp->chgBit  (c+208,(vlTOPp->top__DOT__cpu__DOT__wb_we));
	vcdp->chgBit  (c+209,(vlTOPp->top__DOT__cpu__DOT__ex_trap_valid));
	vcdp->chgBus  (c+210,(vlTOPp->top__DOT__cpu__DOT__ex_exception),4);
	vcdp->chgBus  (c+211,(vlTOPp->top__DOT__cpu__DOT__ex_exc_data),32);
	vcdp->chgBus  (c+212,(vlTOPp->top__DOT__cpu__DOT__ex_rs1),5);
	vcdp->chgBus  (c+213,(vlTOPp->top__DOT__cpu__DOT__ex_pc),32);
	vcdp->chgBus  (c+214,(vlTOPp->top__DOT__cpu__DOT__ex_instruction),32);
	vcdp->chgBus  (c+215,(vlTOPp->top__DOT__cpu__DOT__ex_port_a),32);
	vcdp->chgBus  (c+216,(vlTOPp->top__DOT__cpu__DOT__ex_port_b),32);
	vcdp->chgBus  (c+217,(vlTOPp->top__DOT__cpu__DOT__ex_alu_op),4);
	vcdp->chgBus  (c+218,(vlTOPp->top__DOT__cpu__DOT__ex_waddr),5);
	vcdp->chgBit  (c+219,(vlTOPp->top__DOT__cpu__DOT__ex_we));
	vcdp->chgBus  (c+220,(vlTOPp->top__DOT__cpu__DOT__ex_mem_flags),6);
	vcdp->chgBit  (c+221,(vlTOPp->top__DOT__cpu__DOT__ex_mem_ex_sel));
	vcdp->chgBus  (c+222,(vlTOPp->top__DOT__cpu__DOT__ex_csr_op),3);
	vcdp->chgBus  (c+223,(vlTOPp->top__DOT__cpu__DOT__ex_csr_data),32);
	vcdp->chgBus  (c+224,(vlTOPp->top__DOT__cpu__DOT__ex_csr_addr),12);
	vcdp->chgBit  (c+225,(vlTOPp->top__DOT__cpu__DOT__ex_fence_op));
	vcdp->chgBit  (c+226,(vlTOPp->top__DOT__cpu__DOT__ex_xret_op));
	vcdp->chgBus  (c+227,(vlTOPp->top__DOT__cpu__DOT__ex_store_data),32);
	vcdp->chgBus  (c+228,(vlTOPp->top__DOT__cpu__DOT__mem_pc),32);
	vcdp->chgBus  (c+229,(vlTOPp->top__DOT__cpu__DOT__mem_instruction),32);
	vcdp->chgBus  (c+230,(vlTOPp->top__DOT__cpu__DOT__mem_waddr),5);
	vcdp->chgBus  (c+231,(vlTOPp->top__DOT__cpu__DOT__mem_rs1),5);
	vcdp->chgBit  (c+232,(vlTOPp->top__DOT__cpu__DOT__mem_we));
	vcdp->chgBus  (c+233,(vlTOPp->top__DOT__cpu__DOT__mem_mem_flags),6);
	vcdp->chgBit  (c+234,(vlTOPp->top__DOT__cpu__DOT__mem_mem_ex_sel));
	vcdp->chgBus  (c+235,(vlTOPp->top__DOT__cpu__DOT__mem_csr_data),32);
	vcdp->chgBus  (c+236,(vlTOPp->top__DOT__cpu__DOT__mem_csr_op),3);
	vcdp->chgBus  (c+237,(vlTOPp->top__DOT__cpu__DOT__mem_csr_addr),12);
	vcdp->chgBit  (c+238,(vlTOPp->top__DOT__cpu__DOT__mem_trap_valid_i));
	vcdp->chgBus  (c+239,(vlTOPp->top__DOT__cpu__DOT__mem_exception_i),4);
	vcdp->chgBus  (c+240,(vlTOPp->top__DOT__cpu__DOT__mem_exc_data_i),32);
	vcdp->chgBit  (c+241,((1U & ((IData)(vlTOPp->top__DOT__cpu__DOT__mem_mem_flags) 
				     >> 5U))));
	vcdp->chgBit  (c+242,((1U & ((IData)(vlTOPp->top__DOT__cpu__DOT__mem_mem_flags) 
				     >> 4U))));
	vcdp->chgBit  (c+243,((1U & ((IData)(vlTOPp->top__DOT__cpu__DOT__mem_mem_flags) 
				     >> 3U))));
	vcdp->chgBit  (c+244,((1U & ((IData)(vlTOPp->top__DOT__cpu__DOT__mem_mem_flags) 
				     >> 2U))));
	vcdp->chgBit  (c+245,((1U & ((IData)(vlTOPp->top__DOT__cpu__DOT__mem_mem_flags) 
				     >> 1U))));
	vcdp->chgBit  (c+246,((1U & (IData)(vlTOPp->top__DOT__cpu__DOT__mem_mem_flags))));
	vcdp->chgBus  (c+247,(vlTOPp->top__DOT__cpu__DOT__mem_store_data),32);
	vcdp->chgBit  (c+248,(vlTOPp->top__DOT__cpu__DOT__mem_fence_op));
	vcdp->chgBit  (c+249,(vlTOPp->top__DOT__cpu__DOT__mem_xret_op));
	vcdp->chgBus  (c+250,(vlTOPp->top__DOT__cpu__DOT__wb_result_mem),32);
	vcdp->chgBus  (c+251,(vlTOPp->top__DOT__cpu__DOT__wb_pc),32);
	vcdp->chgBus  (c+252,(vlTOPp->top__DOT__cpu__DOT__wb_instruction),32);
	vcdp->chgBus  (c+253,(vlTOPp->top__DOT__cpu__DOT__wb_rs1),5);
	vcdp->chgBus  (c+254,(vlTOPp->top__DOT__cpu__DOT__wb_csr_data),32);
	vcdp->chgBus  (c+255,(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr),12);
	vcdp->chgBus  (c+256,(vlTOPp->top__DOT__cpu__DOT__wb_csr_op),3);
	vcdp->chgBit  (c+257,(vlTOPp->top__DOT__cpu__DOT__wb_trap_valid));
	vcdp->chgBus  (c+258,(vlTOPp->top__DOT__cpu__DOT__wb_exception),4);
	vcdp->chgBus  (c+259,(vlTOPp->top__DOT__cpu__DOT__wb_exc_data),32);
	vcdp->chgBit  (c+260,(vlTOPp->top__DOT__cpu__DOT__wb_fence_op));
	vcdp->chgBit  (c+261,(vlTOPp->top__DOT__cpu__DOT__wb_xret_op));
	vcdp->chgBus  (c+262,(((IData)(4U) + vlTOPp->top__DOT__cpu__DOT__if_pc)),32);
	vcdp->chgBit  (c+263,((0U != (3U & vlTOPp->top__DOT__cpu__DOT__if_pc))));
	vcdp->chgBit  (c+264,(((IData)(vlTOPp->top__DOT__cpu__DOT__wb_we) 
			       & (~ (IData)(vlTOPp->top__DOT__cpu__DOT__wb_trap_valid)))));
	vcdp->chgBus  (c+265,((0xfffU & (vlTOPp->top__DOT__cpu__DOT__id_instruction 
					 >> 0x14U))),12);
	vcdp->chgBus  (c+266,((0x7fU & vlTOPp->top__DOT__cpu__DOT__id_instruction)),7);
	vcdp->chgBus  (c+267,((7U & (vlTOPp->top__DOT__cpu__DOT__id_instruction 
				     >> 0xcU))),3);
	vcdp->chgBus  (c+268,((0x7fU & (vlTOPp->top__DOT__cpu__DOT__id_instruction 
					>> 0x19U))),7);
	vcdp->chgBit  (c+269,((0U != (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_op))));
	vcdp->chgBus  (c+270,(vlTOPp->top__DOT__cpu__DOT__LSU__DOT__i_state),2);
	vcdp->chgBus  (c+271,(vlTOPp->top__DOT__cpu__DOT__LSU__DOT__d_state),2);
	vcdp->chgBit  (c+272,(vlTOPp->top__DOT__cpu__DOT__LSU__DOT__kill));
	vcdp->chgBit  (c+273,(((2U == (IData)(vlTOPp->top__DOT__cpu__DOT__ex_exception)) 
			       & (IData)(vlTOPp->top__DOT__cpu__DOT__ex_trap_valid))));
	vcdp->chgBit  (c+274,(((0xbU == (IData)(vlTOPp->top__DOT__cpu__DOT__ex_exception)) 
			       | ((3U == (IData)(vlTOPp->top__DOT__cpu__DOT__ex_exception)) 
				  & (IData)(vlTOPp->top__DOT__cpu__DOT__ex_trap_valid)))));
	vcdp->chgBit  (c+275,((0U != (IData)(vlTOPp->top__DOT__cpu__DOT__ex_csr_op))));
	vcdp->chgBit  (c+276,((0U != (IData)(vlTOPp->top__DOT__cpu__DOT__mem_csr_op))));
	vcdp->chgBus  (c+277,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mstatus),32);
	vcdp->chgBus  (c+278,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mie),32);
	vcdp->chgBus  (c+279,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mtvec),32);
	vcdp->chgBus  (c+280,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mscratch),32);
	vcdp->chgBus  (c+281,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mepc),32);
	vcdp->chgBus  (c+282,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mcause),32);
	vcdp->chgBus  (c+283,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mtval),32);
	vcdp->chgBus  (c+284,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mip),32);
	vcdp->chgQuad (c+285,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mcycle),64);
	vcdp->chgQuad (c+287,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__minstret),64);
	vcdp->chgBit  (c+289,((0U != (IData)(vlTOPp->top__DOT__cpu__DOT__wb_rs1))));
	vcdp->chgBit  (c+290,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mstatus_mpie));
	vcdp->chgBit  (c+291,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mstatus_mie));
	vcdp->chgBit  (c+292,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mie_meie));
	vcdp->chgBit  (c+293,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mie_mtie));
	vcdp->chgBit  (c+294,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mie_msie));
	vcdp->chgBit  (c+295,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mcause_int));
	vcdp->chgBus  (c+296,(vlTOPp->top__DOT__cpu__DOT__CSR__DOT__mcause_exc),4);
	vcdp->chgBit  (c+297,((0x301U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+298,((0xf14U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+299,((0xf11U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+300,((0xf12U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+301,((0x300U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+302,((0x304U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+303,((0x305U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+304,((0x341U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+305,((0x342U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+306,((0x343U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+307,((0x344U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+308,((0xb00U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+309,((0xb02U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+310,((0xb80U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+311,((0xb82U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+312,((0x340U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_csr_addr))));
	vcdp->chgBit  (c+313,((0xbU == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_exception))));
	vcdp->chgBit  (c+314,((3U == (IData)(vlTOPp->top__DOT__cpu__DOT__wb_exception))));
	vcdp->chgBus  (c+315,((0xfffffcU & vlTOPp->top__DOT__cpu__DOT__if_pc)),24);
	vcdp->chgBus  (c+316,((0xfffffcU & vlTOPp->top__DOT__cpu__DOT__mem_result)),24);
	vcdp->chgBit  (c+317,((0x80U == (0xffU & (vlTOPp->top__DOT__cpu__DOT__if_pc 
						  >> 0x18U)))));
	vcdp->chgBit  (c+318,((0x80U == (0xffU & (vlTOPp->top__DOT__cpu__DOT__mem_result 
						  >> 0x18U)))));
    }
}

void Vtop::traceChgThis__6(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+319,(vlTOPp->clk_i));
	vcdp->chgBit  (c+320,(vlTOPp->rst_i));
	vcdp->chgBit  (c+321,(((IData)(vlTOPp->rst_i) 
			       | (IData)(vlTOPp->top__DOT__cpu__DOT__exception_stall_req))));
    }
}
