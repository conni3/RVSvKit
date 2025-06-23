---
title: 02-module-inventory
draft: false
weight: "9"
aliases: [Module Inventory]
linter-yaml-title-alias: Module Inventory
---
# Module Inventory

This document catalogs every leaf RTL block under `modules/`.  
(For full repo layout, refer to [[01-overview]].)

## Folder Sub-tree

```text
RVSvKit/
└── modules/
    ├── arithmetic/
    │   ├── half_adder/
    │   ├── adder/
    │   ├── multiplier/
    │   └── divider/
    ├── logic/
    │   ├── comparator/       # EQ, NE, SLT, SGE, etc.
    │   ├── bitwise_and/
    │   ├── bitwise_or/
    │   └── bitwise_xor/
    ├── register/
    │   ├── register/         # single-flop with sync reset
    │   ├── pipeline_reg/     # ready-valid pipeline stage
    │   └── reg_file/         # parameterized register file
    ├── control/
    │   ├── immediate_generator/  # I/S/B/U/J-type extraction
    │   ├── branch_unit/          # branch comparison & target logic
    │   └── control_fsm/          # simple state-machine for pipeline control
    ├── memory/
    │   ├── load_store_unit/   # aligned/misaligned loads & stores
    │   ├── fifo/              # small synchronous FIFO
    │   └── cache_wrap/        # write-through cache wrapper
    └── pipeline/
        ├── decoupled_reg/     # ready-valid latch
        ├── hazard_unit/       # RAW/WAR/WAW detection
        └── forwarding_unit/   # bypass multiplexers
```

## 1. Initial Modules

### arithmetic/

- **half_adder** — 1-bit sum & carry
	
- **adder** — N-bit add/sub with carry in/out
	
- **multiplier** — iterative or Booth-based multiply
	
- **divider** — restoring/non-restoring divider

### logic/

- **comparator** — EQ, NE, SLT, SGE (signed/unsigned)
	
- **bitwise_and**, **bitwise_or**, **bitwise_xor**

### register/

- **register** — parameterized flop with synchronous reset
	
- **pipeline_reg** — ready-valid pipeline stage register
	
- **reg_file** — multi-port register file

### control/

- **immediate_generator** — extracts I/S/B/U/J immediates
	
- **branch_unit** — computes branch decisions & targets
	
- **control_fsm** — FSM for simple instruction sequencing

### memory/

- **load_store_unit** — performs aligned loads/stores, raises misalign trap
	
- **fifo** — synchronous FIFO with almost-full/empty flags
	
- **cache_wrap** — write-through cache interface wrapper

### pipeline/

- **decoupled_reg** — back-pressure-aware pipeline latch
	
- **hazard_unit** — detects RAW/WAR/WAW hazards
	
- **forwarding_unit** — data bypass network

---

## 2. Future Modules

- **CSR file & trap handler** — full privileged CSR set, exception delegation
	
- **Multiplier/divider variants** — pipelined, SRT, non-restoring algorithms
	
- **Cache enhancements** — write-back, set-associative, MESI protocol
	
- **MMU stubs** — simple page tables & TLB interfaces
	
- **DRAM controller** — AXI-compliant DDR3/DDR4 interface
	
- **Vector unit** — RVV-style SIMD lanes

---

## 3. Protocol Adaptors (in `protocols/`)

See **docs/05-ci-and-testing.md** and **docs/04-packages-and-interfaces.md** for full TileLink ↔ AXI4-Lite, APB adapter listings.