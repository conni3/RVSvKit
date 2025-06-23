// sim_main.cpp
#include <verilated.h>
#include "verilated_vcd_c.h"

// 1) include every TB you want to be able to run:
#include "Vhalf_adder_tb.h"
// … add more as you create new_*_tb.sv modules

#include <iostream>
#include <string>
#include <map>
#include <functional>

// 2) templated runner
template<typename TB>
int run_tb(const std::string &name, int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    auto tb = new TB;
    auto tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open((name + ".vcd").c_str());

    for (vluint64_t tick = 0; !Verilated::gotFinish(); ++tick) {
        // assume all your TBs have a .clk; if not, adjust per-TB
        tb->clk = tick & 1;
        tb->eval();
        tfp->dump(10*tick);
    }

    tfp->close();
    delete tb;
    delete tfp;
    // reset for next run
    Verilated::gotFinish(false);
    return 0;
}

int main(int argc, char **argv) {
    // 3) build map of available tests
    std::map<std::string, std::function<int()>> tests = {
        { "half_adder_tb",
            [&](){ return run_tb<Vhalf_adder_tb>("half_adder_tb", argc, argv); }
        },
        // … add entries here whenever you add a new TB
    };

    // pick test by name
    std::string name = (argc>1 ? argv[1] : tests.begin()->first);
    auto it = tests.find(name);
    if (it == tests.end()) {
        std::cerr << "Unknown testbench: " << name << "\nAvailable:";
        for (auto &kv : tests) std::cerr << " " << kv.first;
        std::cerr << "\n";
        return 1;
    }
    return it->second();
}
