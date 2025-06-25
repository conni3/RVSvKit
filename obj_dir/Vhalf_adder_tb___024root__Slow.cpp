// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vhalf_adder_tb.h for the primary calling header

#include "Vhalf_adder_tb__pch.h"
#include "Vhalf_adder_tb__Syms.h"
#include "Vhalf_adder_tb___024root.h"

void Vhalf_adder_tb___024root___ctor_var_reset(Vhalf_adder_tb___024root* vlSelf);

Vhalf_adder_tb___024root::Vhalf_adder_tb___024root(Vhalf_adder_tb__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vhalf_adder_tb___024root___ctor_var_reset(this);
}

void Vhalf_adder_tb___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vhalf_adder_tb___024root::~Vhalf_adder_tb___024root() {
}
