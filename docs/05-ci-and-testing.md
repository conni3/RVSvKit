---
title: 05-ci-and-testing
draft: false
weight: "6"
---
# CI & Testing

This document defines the continuous-integration pipelines, smoke synthesis, functional regression, benchmarking, and gating thresholds for **RVSvKit**, consistent with the Overview and Module Inventory.

## 1. CI Pipelines (in `ci/`)

|Pipeline|Tool|Trigger|Purpose|
|---|---|---|---|
|**verilator.yml**|Verilator|PR / push to `main`|Functional lint & simulation|
|**icarus.yml**|Icarus Verilog|PR / push to `main`|RTL simulation with testbenches|
|**vivado_docker.yml**|Vivado (Docker)|Nightly / scheduled|Synthesis smoke, area & timing measurements|

Each pipeline reports pass/fail status, code coverage, and synthesis metrics via badges in `README.md`.

## 2. Functional CI

- **Regression tests**:
    
    - Run all testbenches under `modules/**/tb/` using Verilator & Icarus.
        
    - Gate on **0 new assertions**, **no regressions**, and **≥ 95% line coverage** per module.
        
- **Coverage collection**:
    
    - Verilator generates coverage data (`.gcov`).
        
    - Coverage thresholds defined in `ci/thresholds.json`.
        

## 3. Synthesis CI

- **Smoke Synthesis**:
    
    - Quick synth of each module wrapper (in `ci/smoke/`) at default parameters.
        
    - Capture utilization: LUTs, FFs, BRAMs, DSPs.
        
- **Baseline thresholds**:
    
    - Defined in `ci/thresholds.json` (e.g., `adder: LUTs ≤ 50`, `multiplier: LUTs ≤ 200`).
        
    - Fail CI if any metric exceeds its threshold.
        
- **Timing checks**:
    
    - Report worst negative slack (WNS) at typical PVT corner.
        
    - Gate on WNS ≥ −1 ns margin.
        

## 4. Benchmarking & Metrics

- **Historical logging**:
    
    - CSV files under `ci/benchmarks/` record date, module name, LUTs, FFs, WNS, coverage.
        
    - PRs that change resource usage must include updated CSV entries.
        
- **Trend visualization**:
    
    - Scripts in `scripts/sweep_params.py` can plot resource trends over time.
        

## 5. Additional Quality Gates

- **Linting**:
    
    - Enforce SV style via `svlint` matching `03-coding-conventions.md`.
        
- **Static Timing Analysis (STA)**:
    
    - Full P&R run on `examples/simple_soc` scheduled weekly.
        
- **Security & Dependency Checks**:
    
    - Scan for unapproved DPI imports.
        
    - Check Docker images for CVEs.
        

---
