// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Prototypes for DPI import and export functions.
//
// Verilator includes this file in all generated .cpp files that use DPI functions.
// Manually include this file where DPI .c import functions are declared to insure
// the C functions match the expectations of the DPI imports.

#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    
    // DPI EXPORTS
    // DPI export at tests/verilator/ram.v:127
    extern void dpi_load_mem (const char* filename);
    // DPI export at tests/verilator/ram.v:108
    extern char dpi_read_byte (int address);
    // DPI export at tests/verilator/ram.v:97
    extern int dpi_read_word (int address);
    // DPI export at tests/verilator/ram.v:116
    extern void dpi_write_word (int address, int data);
    
    // DPI IMPORTS
    // DPI import at tests/verilator/ram.v:95
    extern void c_load_mem (const svOpenArrayHandle mem, const char* filename);
    
#ifdef __cplusplus
}
#endif
