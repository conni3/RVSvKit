// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vhalf_adder_tb.h for the primary calling header

#ifndef VERILATED_VHALF_ADDER_TB___024UNIT_H_
#define VERILATED_VHALF_ADDER_TB___024UNIT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vhalf_adder_tb__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vhalf_adder_tb___024unit final : public VerilatedModule {
  public:

    // INTERNAL VARIABLES
    Vhalf_adder_tb__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vhalf_adder_tb___024unit(Vhalf_adder_tb__Syms* symsp, const char* v__name);
    ~Vhalf_adder_tb___024unit();
    VL_UNCOPYABLE(Vhalf_adder_tb___024unit);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
