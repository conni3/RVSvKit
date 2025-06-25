// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vhalf_adder_tb.h for the primary calling header

#ifndef VERILATED_VHALF_ADDER_TB___024ROOT_H_
#define VERILATED_VHALF_ADDER_TB___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vhalf_adder_tb__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vhalf_adder_tb___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VactIterCount;
    VlDelayScheduler __VdlySched;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vhalf_adder_tb__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vhalf_adder_tb___024root(Vhalf_adder_tb__Syms* symsp, const char* v__name);
    ~Vhalf_adder_tb___024root();
    VL_UNCOPYABLE(Vhalf_adder_tb___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
