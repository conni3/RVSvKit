# RVSvKit

[![Verilator CI](https://github.com/you/RVSvKit/actions/workflows/verilator.yml/badge.svg)]() [![Synthesis CI](https://github.com/you/RVSvKit/actions/workflows/vivado_docker.yml/badge.svg)]()

Welcome to **RVSvKit**, a lightweight, parameterized SystemVerilog library for building RISC-V–style pipelines and peripherals. This kit provides modular building blocks, clear CI flows, and extensible protocol adapters to accelerate your RISC-V development :contentReference[oaicite:0]{index=0}.

---

## Motivation & Goals

- **Modular RTL Primitives**  
  Provide n-bit–parametrized ALUs, registers, control FSMs, and more.

- **Seamless Verification Flow**  
  Integrate Verilator and Dockerized Vivado for CI and smoke synthesis.

- **Extensible Protocol Adapters**  
  Support TileLink ↔ AXI4-Lite, APB adapters, crossbars, and arbiters :contentReference[oaicite:1]{index=1}.

---

## Key Features

- **Composable Pipeline Primitives**  
  Decoupled ready-valid registers, hazard detection, forwarding units, and a simple 5-stage core example :contentReference[oaicite:2]{index=2}.  
- **CSR & Trap Handler**  
  Base RISC-V privileged CSRs (mstatus, mtvec, mie, mip, mepc, mcause) with exception flow.  
- **Protocol Adapters**  
  TileLink ↔ AXI4-Lite and APB adapters, with generics for easy scaling :contentReference[oaicite:3]{index=3}.  
- **CI & Benchmarking**  
  Functional regression, smoke synthesis, coverage gating, and area/timing thresholds :contentReference[oaicite:4]{index=4}.  
- **Automation & Optimization**  
  Scaffolding scripts, parameter sweeps, RTL optimization guidelines, and static-analysis reporting :contentReference[oaicite:5]{index=5}.  

---

## Prerequisites

- **Verilator** ≥ 4.x  
- **Docker** & **Vivado** (2023.2+) for synthesis CI  

---

## Getting Started

```bash
git clone https://github.com/you/RVSvKit.git
cd RVSvKit
make run
```

---

## Folder Structure

```
RVSvKit/
├── common/                   # shared packages & utilities
│   ├── pkg/                  # types, parameters, macros
│   └── utils/                # assertions & small helpers
├── modules/                  # all synthesizable RTL blocks
├── protocols/                # TileLink, AXI, APB stacks & adapters
├── examples/                 # end-to-end demos (simple_soc, tutorials)
├── docs/                     # deep dives, diagrams, tutorials
├── ci/                       # GitHub Actions / thresholds
├── scripts/                  # scaffolding & automation tools
├── Dockerfile & docker/      # dev container setup
├── .gitignore
├── LICENSE
└── CONTRIBUTING.md
```

---

## Documentation

Overview: project goals, features, and basic usage 

Module Inventory: catalog of all RTL leaf blocks

Coding Conventions: style guide for SystemVerilog

Packages & Interfaces: shared packages and bus-interface abstractions

CI & Testing: continuous integration pipelines and gating thresholds

Automation & Optimization: scaffolding tools, sweeps, and RTL guidelines

Contributing & Versioning: how to contribute and release policy

--- 

## Contributing

We welcome internal team feedback. External contributions will open once we reach v1.0.0. See CONTRIBUTING.md for detailed guidelines

--- 

## License

This project is licensed under the MIT License. See the LICENSE file for details.