// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header

#ifndef _Vtop__Syms_H_
#define _Vtop__Syms_H_

#include "verilated_heavy.h"

// INCLUDE MODULE CLASSES
#include "Vtop.h"

// DPI TYPES for DPI Export callbacks (Internal use)
typedef void (*Vtop__Vcb_dpi_load_mem_t) (Vtop__Syms* __restrict vlSymsp, const std::string& filename);
typedef void (*Vtop__Vcb_dpi_read_byte_t) (Vtop__Syms* __restrict vlSymsp, IData address, CData& dpi_read_byte__Vfuncrtn);
typedef void (*Vtop__Vcb_dpi_read_word_t) (Vtop__Syms* __restrict vlSymsp, IData address, IData& dpi_read_word__Vfuncrtn);
typedef void (*Vtop__Vcb_dpi_write_word_t) (Vtop__Syms* __restrict vlSymsp, IData address, IData data);

// SYMS CLASS
class Vtop__Syms : public VerilatedSyms {
  public:
    
    // LOCAL STATE
    const char* __Vm_namep;
    bool __Vm_activity;  ///< Used by trace routines to determine change occurred
    bool __Vm_didInit;
    
    // SUBCELL STATE
    Vtop*                          TOPp;
    
    // SCOPE NAMES
    VerilatedScope __Vscope_top__memory;
    
    // CREATORS
    Vtop__Syms(Vtop* topp, const char* namep);
    ~Vtop__Syms() {}
    
    // METHODS
    inline const char* name() { return __Vm_namep; }
    inline bool getClearActivity() { bool r=__Vm_activity; __Vm_activity=false; return r; }
    
} VL_ATTR_ALIGNED(64);

#endif // guard
