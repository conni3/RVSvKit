// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vhalf_adder_tb.h for the primary calling header

#include "Vhalf_adder_tb__pch.h"
#include "Vhalf_adder_tb___024root.h"

VlCoroutine Vhalf_adder_tb___024root___eval_initial__TOP__Vtiming__0(Vhalf_adder_tb___024root* vlSelf);

void Vhalf_adder_tb___024root___eval_initial(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_initial\n"); );
    // Body
    Vhalf_adder_tb___024root___eval_initial__TOP__Vtiming__0(vlSelf);
}

VL_INLINE_OPT VlCoroutine Vhalf_adder_tb___024root___eval_initial__TOP__Vtiming__0(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_initial__TOP__Vtiming__0\n"); );
    // Init
    QData/*63:0*/ __Vtask_loop_all_values__0__step;
    __Vtask_loop_all_values__0__step = 0;
    IData/*31:0*/ __Vtask_loop_all_values__0__unnamedblk1__DOT__i;
    __Vtask_loop_all_values__0__unnamedblk1__DOT__i = 0;
    IData/*31:0*/ __Vtask_loop_all_values__0__max_val;
    __Vtask_loop_all_values__0__max_val = 0;
    // Body
    __Vtask_loop_all_values__0__step = 5ULL;
    __Vtask_loop_all_values__0__max_val = 4U;
    __Vtask_loop_all_values__0__unnamedblk1__DOT__i = 0U;
    while (VL_LTS_III(32, __Vtask_loop_all_values__0__unnamedblk1__DOT__i, __Vtask_loop_all_values__0__max_val)) {
        co_await vlSelf->__VdlySched.delay((0x3e8ULL 
                                            * __Vtask_loop_all_values__0__step), 
                                           nullptr, 
                                           "common/pkg/tb_util_pkg.sv", 
                                           28);
        __Vtask_loop_all_values__0__unnamedblk1__DOT__i 
            = ((IData)(1U) + __Vtask_loop_all_values__0__unnamedblk1__DOT__i);
    }
    VL_FINISH_MT("modules/arithmetic/half_adder/tb/half_adder_tb.sv", 22, "");
}

void Vhalf_adder_tb___024root___eval_act(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_act\n"); );
}

void Vhalf_adder_tb___024root___eval_nba(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_nba\n"); );
}

void Vhalf_adder_tb___024root___timing_resume(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___timing_resume\n"); );
    // Body
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        vlSelf->__VdlySched.resume();
    }
}

void Vhalf_adder_tb___024root___eval_triggers__act(Vhalf_adder_tb___024root* vlSelf);

bool Vhalf_adder_tb___024root___eval_phase__act(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vhalf_adder_tb___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vhalf_adder_tb___024root___timing_resume(vlSelf);
        Vhalf_adder_tb___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vhalf_adder_tb___024root___eval_phase__nba(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vhalf_adder_tb___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vhalf_adder_tb___024root___dump_triggers__nba(Vhalf_adder_tb___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vhalf_adder_tb___024root___dump_triggers__act(Vhalf_adder_tb___024root* vlSelf);
#endif  // VL_DEBUG

void Vhalf_adder_tb___024root___eval(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vhalf_adder_tb___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("modules/arithmetic/half_adder/tb/half_adder_tb.sv", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vhalf_adder_tb___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("modules/arithmetic/half_adder/tb/half_adder_tb.sv", 3, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vhalf_adder_tb___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vhalf_adder_tb___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vhalf_adder_tb___024root___eval_debug_assertions(Vhalf_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhalf_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhalf_adder_tb___024root___eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG
