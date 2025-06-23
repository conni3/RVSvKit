// sim_main_minimal.cpp
// A minimal Verilator driver for purely combinational testbenches.
// It steps through all initial/# delays until the SV $finish triggers Verilated::gotFinish().

#include "Vhalf_adder_tb.h"   // ← your TB’s generated header
#include "verilated.h"
#if VM_TRACE
  #include "verilated_vcd_c.h"
#endif

//----------------------------------------------------------------------
// Track simulation time in “time units” (with `\`timescale 1ns/1ps\` in SV, 1 unit = 1 ns)
static vluint64_t main_time = 0;

// Called by $time in SystemVerilog
double sc_time_stamp() {
    return main_time;
}
//----------------------------------------------------------------------

int main(int argc, char **argv) {
    // forward any +args to Verilator (e.g. +trace+)
    Verilated::commandArgs(argc, argv);

    // instantiate your TB
    auto tb = new Vhalf_adder_tb;

#if VM_TRACE
    // optional: enable VCD tracing if you build with -DVM_TRACE
    Verilated::traceEverOn(true);
    auto tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open("waveform.vcd");
#endif

    // keep calling eval() and advancing time until your SV tb does `$finish;`
    while (!Verilated::gotFinish()) {
        tb->eval();        // evaluate logic at current time
        main_time += 1;    // advance time by 1 unit (1 ns)
    }

#if VM_TRACE
    tfp->close();
    delete tfp;
#endif
    delete tb;
    return 0;
}
