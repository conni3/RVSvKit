---
title: 07-contributing-and-versioning
draft: false
weight: "4"
---
# Contributing & Versioning

This document outlines how to contribute to **RVSvKit**, our branching and release policies, and our roadmap for future enhancements. It’s designed to align with the **Overview** and **Module Inventory** docs.

## 1. Contributing Guidelines

- **Contributions Status**
    
    - At present, **RVSvKit is not accepting external PRs** until we formalize the module API and CI stability.
        
    - We plan to open contributions when the core API (under `modules/`, `common/`, `protocols/`) reaches version 1.0.0.
        
- **Future Process**
    
    - We will provide a `CONTRIBUTING.md` template with:
        
        - Issue template (bug report, feature request)
            
        - PR template (description, test instructions, impact analysis)
            
    - All contributions will require:
        
        1. Pass all CI pipelines (`verilator.yml`, `icarus.yml`, `vivado_docker.yml`)
            
        2. Adhere to `03-coding-conventions.md` style rules
            
        3. Update `ci/benchmark` CSV if resource usage changes
            
        4. Include or update tests in the appropriate `tb/` directory
            

## 2. Branching & Release Policy

- **Branching Model**
    
    - `main` branch holds the latest stable release.
        
    - Feature branches prefixed with `feature/` for new API or core modules.
        
    - Hotfix branches prefixed with `hotfix/` for critical bug fixes against releases.
        
- **Versioning**
    
    - We follow [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`
        
        - **MAJOR**: incompatible API or backward-breaking changes
            
        - **MINOR**: backward-compatible feature additions
            
        - **PATCH**: backward-compatible bug fixes
            
- **Release Checklist**
    
    1. All CI pipelines pass
        
    2. Changelog entry in `docs/CHANGELOG.md`
        
    3. Tag release in Git: `vX.Y.Z`
        
    4. Update version in `common/pkg/common_pkg.sv` header comment
        
    5. Publish GitHub release with release notes
        

## 3. Roadmap & Future Improvements

We strive for incremental progress with clear ETAs (quarters refer to calendar year 2025):

|Feature|Status|ETA|
|---|---|---|
|CSR file & trap handler|In design|Q3 2025|
|Multiplier/divider variants|Planned|Q4 2025|
|Cache enhancements (write-back)|Planned|Q1 2026|
|MMU stubs & TLB interfaces|Research|Q2 2026|
|DRAM controller (DDR3/DDR4)|Future|Q3 2026|
|Vector unit (RVV lanes)|Future|Q4 2026|

## 4. Open Ideas & Feedback

- We welcome **internal team discussions** via GitHub Discussions or project boards before opening to the public.
    
- If you have suggestions—module ideas, protocol enhancements, automation tips—please document them as **GitHub Issues** under the appropriate label: `enhancement`, `performance`, or `docs`.
    

---

_Refer to [01-overview](/posts/01-overview/) for full repo layout, [02-module-inventory](/posts/02-module-inventory/) for module catalog, and [03-coding-conventions](/posts/03-coding-conventions/) for pipeline details._