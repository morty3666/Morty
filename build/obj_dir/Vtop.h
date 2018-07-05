// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _Vtop_H_
#define _Vtop_H_

#include "verilated_heavy.h"
#include "Vtop__Dpi.h"

class Vtop__Syms;
class VerilatedVcd;

//----------

VL_MODULE(Vtop) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(clk_i,0,0);
    VL_IN8(rst_i,0,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    // Anonymous structures to workaround compiler member-count bugs
    struct {
	VL_SIG8(top__DOT__dwbm_cyc,0,0);
	VL_SIG8(top__DOT__dwbm_sel,3,0);
	VL_SIG8(top__DOT__dwbm_stb,0,0);
	VL_SIG8(top__DOT__dwbm_we,0,0);
	VL_SIG8(top__DOT__iwbm_cyc,0,0);
	VL_SIG8(top__DOT__iwbm_stb,0,0);
	VL_SIG8(top__DOT__iwbm_ack,0,0);
	VL_SIG8(top__DOT__dwbm_ack,0,0);
	VL_SIG8(top__DOT__cpu__DOT__if_pc_sel,1,0);
	VL_SIG8(top__DOT__cpu__DOT__if_trap_valid,0,0);
	VL_SIG8(top__DOT__cpu__DOT__if_exception,3,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_waddr,4,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_we,0,0);
	VL_SIG8(top__DOT__cpu__DOT__id_stall,0,0);
	VL_SIG8(top__DOT__cpu__DOT__id_flush,0,0);
	VL_SIG8(top__DOT__cpu__DOT__forward_a_sel,1,0);
	VL_SIG8(top__DOT__cpu__DOT__forward_b_sel,1,0);
	VL_SIG8(top__DOT__cpu__DOT__id_trap_valid,0,0);
	VL_SIG8(top__DOT__cpu__DOT__id_exception,3,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_trap_valid,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_exception,3,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_rs1,4,0);
	VL_SIG8(top__DOT__cpu__DOT__take_branch,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_alu_op,3,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_waddr,4,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_we,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_mem_flags,5,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_mem_ex_sel,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_csr_op,2,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_fence_op,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_xret_op,0,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_waddr,4,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_rs1,4,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_we,0,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_mem_flags,5,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_mem_ex_sel,0,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_csr_op,2,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_trap_valid_i,0,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_exception_i,3,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_flush,0,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_fence_op,0,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_xret_op,0,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_flush,0,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_rs1,4,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_csr_op,2,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_trap_valid,0,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_exception,3,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_fence_op,0,0);
	VL_SIG8(top__DOT__cpu__DOT__wb_xret_op,0,0);
	VL_SIG8(top__DOT__cpu__DOT__csr_dependence,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ld_dependence,0,0);
	VL_SIG8(top__DOT__cpu__DOT__if_stall_req,0,0);
	VL_SIG8(top__DOT__cpu__DOT__mem_stall_req,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ex_nop,0,0);
	VL_SIG8(top__DOT__cpu__DOT__if_kill,0,0);
	VL_SIG8(top__DOT__cpu__DOT__hazard,0,0);
	VL_SIG8(top__DOT__cpu__DOT__en_fwd,0,0);
	VL_SIG8(top__DOT__cpu__DOT__exception_stall_req,0,0);
	VL_SIG8(top__DOT__cpu__DOT__exception_sel_flag,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__rs1,4,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__rs2,4,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__comparator_op,2,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__waddr,4,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__porta_sel,0,0);
    };
    struct {
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__take_branch,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__pc_jexc,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__pc_bexc,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lui,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__auipc,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__jal,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__jalr,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__beq,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__bne,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__blt,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__bge,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__bltu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__bgeu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lb,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lh,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lw,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lbu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__lhu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sb,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sh,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sw,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__addi,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__slti,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sltiu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__xori,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__ori,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__andi,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__slli,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__srli,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__srai,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__add,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sub,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sll,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__slt,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sltu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT___xor,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__srl,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__sra,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT___or,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT___and,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__fence,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__fencei,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__xret,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rw,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rs,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rc,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rwi,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rsi,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__rci,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__call,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT___break,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_b,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_imm,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_st,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_ld,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_add,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sub,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_and,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_xor,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_or,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sll,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sr,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_shift,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_slt,0,0);
    };
    struct {
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_sltu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_wr,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_alu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_immop,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_ldu,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_j,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_csri,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_csr,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_fence,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_word,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_byte,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__is_hw,0,0);
	VL_SIG8(top__DOT__cpu__DOT__ID__DOT__DCU__DOT__illegal,0,0);
	VL_SIG8(top__DOT__cpu__DOT__MEM__DOT__ld_misaligned,0,0);
	VL_SIG8(top__DOT__cpu__DOT__MEM__DOT__st_misaligned,0,0);
	VL_SIG8(top__DOT__cpu__DOT__MEM__DOT__mem_exception,3,0);
	VL_SIG8(top__DOT__cpu__DOT__MEM__DOT__mem_trap_valid,0,0);
	VL_SIG8(top__DOT__cpu__DOT__FWD__DOT__ex_fwd_a,0,0);
	VL_SIG8(top__DOT__cpu__DOT__FWD__DOT__ex_fwd_b,0,0);
	VL_SIG8(top__DOT__cpu__DOT__FWD__DOT__mem_fwd_a,0,0);
	VL_SIG8(top__DOT__cpu__DOT__FWD__DOT__mem_fwd_b,0,0);
	VL_SIG8(top__DOT__cpu__DOT__FWD__DOT__wb_fwd_a,0,0);
	VL_SIG8(top__DOT__cpu__DOT__FWD__DOT__wb_fwd_b,0,0);
	VL_SIG8(top__DOT__cpu__DOT__LSU__DOT__wsel_o,3,0);
	VL_SIG8(top__DOT__cpu__DOT__LSU__DOT__rsel_o,3,0);
	VL_SIG8(top__DOT__cpu__DOT__LSU__DOT__runsigned,0,0);
	VL_SIG8(top__DOT__cpu__DOT__LSU__DOT__i_state,1,0);
	VL_SIG8(top__DOT__cpu__DOT__LSU__DOT__d_state,1,0);
	VL_SIG8(top__DOT__cpu__DOT__LSU__DOT__kill,0,0);
	VL_SIG8(top__DOT__cpu__DOT__HZ__DOT__csr,0,0);
	VL_SIG8(top__DOT__cpu__DOT__HZ__DOT__ld,0,0);
	VL_SIG8(top__DOT__cpu__DOT__HZ__DOT__xcall_break,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__undef_register,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__mstatus_mpie,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__mstatus_mie,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__mie_meie,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__mie_mtie,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__mie_msie,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__icode,3,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__interrupt,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__mcause_int,0,0);
	VL_SIG8(top__DOT__cpu__DOT__CSR__DOT__mcause_exc,3,0);
	VL_SIG16(top__DOT__cpu__DOT__ex_csr_addr,11,0);
	VL_SIG16(top__DOT__cpu__DOT__mem_csr_addr,11,0);
	VL_SIG16(top__DOT__cpu__DOT__wb_csr_addr,11,0);
	VL_SIG(top__DOT__dwbm_dat_o,31,0);
	VL_SIG(top__DOT__dwbm_dat_i,31,0);
	VL_SIG(top__DOT__iwbm_dat,31,0);
	VL_SIG(top__DOT__cpu__DOT__if_pc,31,0);
	VL_SIG(top__DOT__cpu__DOT__if_exc_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__id_instruction,31,0);
	VL_SIG(top__DOT__cpu__DOT__id_pc,31,0);
	VL_SIG(top__DOT__cpu__DOT__ex_exc_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__pc_branch_addr,31,0);
	VL_SIG(top__DOT__cpu__DOT__ex_pc,31,0);
	VL_SIG(top__DOT__cpu__DOT__ex_instruction,31,0);
	VL_SIG(top__DOT__cpu__DOT__ex_port_a,31,0);
	VL_SIG(top__DOT__cpu__DOT__ex_port_b,31,0);
	VL_SIG(top__DOT__cpu__DOT__ex_csr_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__ex_store_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__mem_pc,31,0);
	VL_SIG(top__DOT__cpu__DOT__mem_instruction,31,0);
	VL_SIG(top__DOT__cpu__DOT__mem_result,31,0);
	VL_SIG(top__DOT__cpu__DOT__mem_csr_data,31,0);
    };
    struct {
	VL_SIG(top__DOT__cpu__DOT__mem_exc_data_i,31,0);
	VL_SIG(top__DOT__cpu__DOT__mem_store_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__mem_load_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__wb_result_mem,31,0);
	VL_SIG(top__DOT__cpu__DOT__wb_pc,31,0);
	VL_SIG(top__DOT__cpu__DOT__wb_instruction,31,0);
	VL_SIG(top__DOT__cpu__DOT__wb_result,31,0);
	VL_SIG(top__DOT__cpu__DOT__wb_csr_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__wb_exc_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__exception_pc,31,0);
	VL_SIG(top__DOT__cpu__DOT__csr_data_o,31,0);
	VL_SIG(top__DOT__cpu__DOT__IF__DOT__if_pc_mux,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT__muxa_i,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT__muxb_i,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT__imm,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT___imm,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT__port_a,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT__port_b,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT___port_b,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT__pc_jump,31,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT__id_exc_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__EX__DOT__ex_result,31,0);
	VL_SIG(top__DOT__cpu__DOT__MEM__DOT__mem_exc_data,31,0);
	VL_SIG(top__DOT__cpu__DOT__MEM__DOT__mem_result,31,0);
	VL_SIG(top__DOT__cpu__DOT__LSU__DOT__wdata,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__csr_wdata,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__mstatus,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__mie,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__mtvec,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__mscratch,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__mepc,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__mcause,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__mtval,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__mip,31,0);
	VL_SIG(top__DOT__cpu__DOT__CSR__DOT__pend_int,31,0);
	VL_SIG64(top__DOT__cpu__DOT__CSR__DOT__mcycle,63,0);
	VL_SIG64(top__DOT__cpu__DOT__CSR__DOT__minstret,63,0);
	VL_SIG(top__DOT__cpu__DOT__ID__DOT__RF__DOT__reg_file[32],31,0);
	VL_SIG8(top__DOT__memory__DOT__mem[16777216],7,0);
    };
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    VL_SIG8(top__DOT__cpu__DOT____Vcellinp__ID__ex_flush_i,0,0);
    VL_SIG8(top__DOT__cpu__DOT____Vcellinp__LSU__mwrite_i,0,0);
    VL_SIG8(__Vclklast__TOP__clk_i,0,0);
    VL_SIG8(__Vchglast__TOP__top__DOT__cpu__DOT__HZ__DOT__xcall_break,0,0);
    VL_SIG(__Vm_traceActivity,31,0);
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vtop__Syms* __VlSymsp;  // Symbol table
    
    // PARAMETERS
    // Parameters marked /*verilator public*/ for use by application code
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vtop);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vtop(const char* name="TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vtop();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options=0);
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval();
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vtop__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vtop__Syms* symsp, bool first);
    static void __Vdpiexp_top__DOT__memory__DOT__dpi_load_mem_TOP(Vtop__Syms* __restrict vlSymsp, const std::string& filename);
    static void __Vdpiexp_top__DOT__memory__DOT__dpi_read_byte_TOP(Vtop__Syms* __restrict vlSymsp, IData address, CData& dpi_read_byte__Vfuncrtn);
    static void __Vdpiexp_top__DOT__memory__DOT__dpi_read_word_TOP(Vtop__Syms* __restrict vlSymsp, IData address, IData& dpi_read_word__Vfuncrtn);
    static void __Vdpiexp_top__DOT__memory__DOT__dpi_write_word_TOP(Vtop__Syms* __restrict vlSymsp, IData address, IData data);
    void __Vdpiimwrap_top__DOT__memory__DOT__c_load_mem__Vdpioc2_TOP(CData (& mem)[16777216], const std::string& filename);
  private:
    static QData _change_request(Vtop__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__4(Vtop__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset();
  public:
    static void _eval(Vtop__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif // VL_DEBUG
  public:
    static void _eval_initial(Vtop__Syms* __restrict vlSymsp);
    static void _eval_settle(Vtop__Syms* __restrict vlSymsp);
    static void _initial__TOP__1(Vtop__Syms* __restrict vlSymsp);
    static void _sequent__TOP__2(Vtop__Syms* __restrict vlSymsp);
    static void _settle__TOP__3(Vtop__Syms* __restrict vlSymsp);
    static void dpi_load_mem(const char* filename);
    static char dpi_read_byte(int address);
    static int dpi_read_word(int address);
    static void dpi_write_word(int address, int data);
    static void traceChgThis(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__2(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__3(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__4(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__5(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__6(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceFullThis(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceFullThis__1(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceInitThis(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceInitThis__1(Vtop__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code);
} VL_ATTR_ALIGNED(128);

#endif // guard
