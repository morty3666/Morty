// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__Syms.h"
#include "Vtop.h"

// FUNCTIONS
Vtop__Syms::Vtop__Syms(Vtop* topp, const char* namep)
	// Setup locals
	: __Vm_namep(namep)
	, __Vm_activity(false)
	, __Vm_didInit(false)
	// Setup submodule names
{
    // Pointer to top level
    TOPp = topp;
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOPp->__Vconfigure(this, true);
    // Setup scope names
    __Vscope_top__memory.configure(this,name(),"top.memory");
    // Setup export functions
    for (int __Vfinal=0; __Vfinal<2; __Vfinal++) {
	__Vscope_top__memory.exportInsert(__Vfinal,"dpi_load_mem", (void*)(&Vtop::__Vdpiexp_top__DOT__memory__DOT__dpi_load_mem_TOP));
	__Vscope_top__memory.exportInsert(__Vfinal,"dpi_read_byte", (void*)(&Vtop::__Vdpiexp_top__DOT__memory__DOT__dpi_read_byte_TOP));
	__Vscope_top__memory.exportInsert(__Vfinal,"dpi_read_word", (void*)(&Vtop::__Vdpiexp_top__DOT__memory__DOT__dpi_read_word_TOP));
	__Vscope_top__memory.exportInsert(__Vfinal,"dpi_write_word", (void*)(&Vtop::__Vdpiexp_top__DOT__memory__DOT__dpi_write_word_TOP));
    }
}
