// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vhalf_adder_tb__pch.h"

//============================================================
// Constructors

Vhalf_adder_tb::Vhalf_adder_tb(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vhalf_adder_tb__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vhalf_adder_tb::Vhalf_adder_tb(const char* _vcname__)
    : Vhalf_adder_tb(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vhalf_adder_tb::~Vhalf_adder_tb() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vhalf_adder_tb___024root___eval_debug_assertions(Vhalf_adder_tb___024root* vlSelf);
#endif  // VL_DEBUG
void Vhalf_adder_tb___024root___eval_static(Vhalf_adder_tb___024root* vlSelf);
void Vhalf_adder_tb___024root___eval_initial(Vhalf_adder_tb___024root* vlSelf);
void Vhalf_adder_tb___024root___eval_settle(Vhalf_adder_tb___024root* vlSelf);
void Vhalf_adder_tb___024root___eval(Vhalf_adder_tb___024root* vlSelf);

void Vhalf_adder_tb::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vhalf_adder_tb::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vhalf_adder_tb___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vhalf_adder_tb___024root___eval_static(&(vlSymsp->TOP));
        Vhalf_adder_tb___024root___eval_initial(&(vlSymsp->TOP));
        Vhalf_adder_tb___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vhalf_adder_tb___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vhalf_adder_tb::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty(); }

uint64_t Vhalf_adder_tb::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vhalf_adder_tb::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vhalf_adder_tb___024root___eval_final(Vhalf_adder_tb___024root* vlSelf);

VL_ATTR_COLD void Vhalf_adder_tb::final() {
    Vhalf_adder_tb___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vhalf_adder_tb::hierName() const { return vlSymsp->name(); }
const char* Vhalf_adder_tb::modelName() const { return "Vhalf_adder_tb"; }
unsigned Vhalf_adder_tb::threads() const { return 1; }
void Vhalf_adder_tb::prepareClone() const { contextp()->prepareClone(); }
void Vhalf_adder_tb::atClone() const {
    contextp()->threadPoolpOnClone();
}

//============================================================
// Trace configuration

VL_ATTR_COLD void Vhalf_adder_tb::trace(VerilatedVcdC* tfp, int levels, int options) {
    vl_fatal(__FILE__, __LINE__, __FILE__,"'Vhalf_adder_tb::trace()' called on model that was Verilated without --trace option");
}
