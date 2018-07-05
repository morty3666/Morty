// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Implementation of DPI export functions.
//
// Verilator compiles this file in when DPI functions are used.
// If you have multiple Verilated designs with the same DPI exported
// function names, you will get multiple definition link errors from here.
// This is an unfortunate result of the DPI specification.
// To solve this, either
//    1. Call Vtop::{export_function} instead,
//       and do not even bother to compile this file
// or 2. Compile all __Dpi.cpp files in the same compiler run,
//       and #ifdefs already inserted here will sort everything out.

#include "Vtop__Dpi.h"
#include "Vtop.h"

#ifndef _VL_DPIDECL_dpi_load_mem
#define _VL_DPIDECL_dpi_load_mem
void dpi_load_mem (const char* filename) {
    // DPI Export at tests/verilator/ram.v:127
    return Vtop::dpi_load_mem(filename);
}
#endif

#ifndef _VL_DPIDECL_dpi_read_byte
#define _VL_DPIDECL_dpi_read_byte
char dpi_read_byte (int address) {
    // DPI Export at tests/verilator/ram.v:108
    return Vtop::dpi_read_byte(address);
}
#endif

#ifndef _VL_DPIDECL_dpi_read_word
#define _VL_DPIDECL_dpi_read_word
int dpi_read_word (int address) {
    // DPI Export at tests/verilator/ram.v:97
    return Vtop::dpi_read_word(address);
}
#endif

#ifndef _VL_DPIDECL_dpi_write_word
#define _VL_DPIDECL_dpi_write_word
void dpi_write_word (int address, int data) {
    // DPI Export at tests/verilator/ram.v:116
    return Vtop::dpi_write_word(address, data);
}
#endif

