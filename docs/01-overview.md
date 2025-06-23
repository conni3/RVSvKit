---
title: 01-overview
weight: "10"
draft: false
aliases: [Overview]
linter-yaml-title-alias: Overview
---
# Overview

_Welcome to **RVSvKit**, a lightweight, parameterized SystemVerilog library for building RISC-V–style pipelines and peripherals._

### Motivation & Goals

- Provide modular, n-bit–parametrized RTL building-blocks (ALU, registers, control FSMs, CSRs, etc.)
	
- Enable a smooth CI & verification flow (Verilator, Icarus, Dockerized Vivado)
	
- Offer clear extension points for caches, MMU stubs, DRAM controllers, vector units

### Key Features

- **Composable Pipeline Primitives**  
	Decoupled ready-valid registers, hazard detection, forwarding units, simple 5-stage core example.
	
- **CSR & Trap Handler**  
	Implements base RISC-V privileged CSRs (mstatus, mtvec, mie, mip, mepc, mcause) and exception flow.
	
- **Protocol Adapters**  
	TileLink ↔ AXI4-Lite, APB adapters; crossbars, arbiters, fragmenters.
	
- **CI & Benchmarking**  
	Per-module smoke synthesis, functional regression, area & timing thresholds, coverage gating.

### Prerequisites & Getting Started

1. **Clone repo**
	
	```bash
    git clone https://github.com/you/RVSvKit.git
    cd RVSvKit
    ```
	
2. **Tools**
	
	- Verilator ≥ 4.x
		
	- Docker & Vivado (2023.2+) for synthesis CI
		
3. **First build & test**
	
	```bash
    make run
    ```

### Folder Hierarchy

Below is the **canonical top-level** layout for the entire repo.  
For the detailed breakdown of leaf RTL blocks, see the **Module Inventory**.

```text
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
├── README.md
└── CONTRIBUTING.md
```

---
