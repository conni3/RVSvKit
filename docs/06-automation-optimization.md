---
title: 06-automation-optimization
draft: false
weight: "5"
---
# Automation & Optimization

This document describes the scaffolding tools, CI/CD automation, parameter sweeps, RTL optimization guidelines, and static-analysis reporting for **RVSvKit**, consistent with Overview and Module Inventory.

## 1. Code Scaffolding (in `scripts/`)

- **scaffold_module.py**  
    Generates new module directory under `modules/<category>/<name>/` with `src/`, `tb/`, and README stub.
    
- **scaffold_pkg.py**  
    Creates package skeleton in `common/pkg/` with standard header comment and `CHANGELOG.md` entry.
    

## 2. CI/CD Automation

- **GitHub Actions**
    
    - Functional CI (`verilator.yml`, `icarus.yml`) on PR/push.
        
    - Synthesis CI (`vivado_docker.yml`) nightly.
        
- **Scheduled Tasks**
    
    - Weekly static timing analysis on `examples/simple_soc`.
        
    - Daily security scan of Docker images for known CVEs.
        

## 3. Parameter Sweeps & Auto‑Tuning

- **sweep_params.py**
    
    - Automates multi-dimensional sweeps over `DATA_WIDTH`, `UNICORE` flag, pipeline depth.
        
    - Collects area, timing, and power metrics into `ci/benchmarks/` CSV files.
        
- **Auto‑Tuner**  
    Future integration: use scripts to search for Pareto‑optimal configurations and update `thresholds.json` automatically.
    

## 4. RTL Optimization Guidelines

- **Multi‑Cycle Operator Pipelining**
    
    - Automate insertion of pipeline registers around long operators (e.g. multipliers) via scripts.
        
- **Resource Utilization Hooks**
    
    - Embed synthesis pragmas (`/* synthesis syn_use_dsp=1 */`) parameterized by `USE_DSP` flag.
        
- **Consistency with Style**
    
    - Generated code honors `03-coding-conventions.md` (indentation, naming, non‑blocking assignments).
        

## 5. Static Analysis & Reporting

- **Linting**
    
    - `svlint` scans for anti-patterns, mixed blocking/non‑blocking usage.
        
- **Assertion Coverage**
    
    - Report assertion pass/fail counts per module.
        
- **Security Checks**
    
    - Enforce no unauthorized DPI imports; flag use of `import "DPI-C"`.
        
- **Dashboard Generation**
    
    - Use a script to convert CSV benchmarks into HTML dashboard under `docs/benchmarks/`.
        

---
