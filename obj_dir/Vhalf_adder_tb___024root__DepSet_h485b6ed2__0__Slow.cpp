// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vhalf_adder_tb.h for the primary calling header

#include "Vhalf_adder_tb__pch.h"
#include "Vhalf_adder_tb___024root.h"

VL_ATTR_COLD void Vhalf_adder_tb___024root___eval_static(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vhalf_adder_tb___024root___eval_final(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vhalf_adder_tb___024root___eval_settle(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vhalf_adder_tb___024root___dump_triggers__act(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vhalf_adder_tb___024root___dump_triggers__nba(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vhalf_adder_tb___024root___ctor_var_reset(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___ctor_var_reset\n"); );
    // Body
    }
