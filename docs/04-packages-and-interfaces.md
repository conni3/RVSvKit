---
title: 04-packages-and-interfaces
draft: false
weight: "7"
---
# Packages & Interfaces

This document outlines the shared packages and bus-interface abstractions for **RVSvKit**, consistent with the Overview and Module Inventory.

## 1. Key Considerations

- **Separation of Concerns**
    
    - `common/pkg/` holds pure types, parameters, macros.
        
    - `protocols/<bus>/interface/` defines signal bundles and handshakes.
        
    - `protocols/<bus>/adapters/` bridges two protocol domains—no mixed responsibilities.
        
- **Parametrization & Scalability**
    
    - Expose `ADDR_WIDTH`, `DATA_WIDTH`, `XLEN`, `ID_WIDTH` in packages and interfaces for easy scaling.
        
    - Interfaces use generics (parameters) rather than hard-coded bus widths.
        
- **Naming & Organization**
    
    - Package files: `<name>_pkg.sv` under `common/pkg/`.
        
    - Interface files: `<bus>_if.sv` under `protocols/<bus>/interface/`.
        
    - Adapter files: `<from>_to_<to>.sv` under `protocols/<bus>/adapters/`.
        
- **Handshake Semantics**  
    Clearly document valid-ready or ready-valid timing relationships in each interface.  
    Use a shared `handshake_if` or utility tasks from packages to enforce back-pressure safely.
    
- **Data & Control Field Mapping**  
    Before coding adapters, tabulate how fields map:
    
    ```text
    TileLink.opcode → AXI4.awprot/arprot
    TileLink.size   → AXI4.awlen/arlen conversion
    ```
    
- **Testing Strategy**
    
    - Behavioral testbenches for every interface and adapter in `protocols/<bus>/tb/`.
        
    - Use common verification tasks from `common/pkg/` to reduce duplication.
        
- **Documentation & Diagrams**
    
    - Keep timing diagrams and mapping tables in `docs/protocols/`.
        
    - Reference spec sections (RISC‑V Privileged Spec, TileLink spec) alongside your prose.
        
- **Version Control & Change Tracking**
    
    - Annotate package versions in header comments (e.g. `// Version 0.1.0`).
        
    - Maintain a `CHANGELOG.md` under `common/pkg/` for interface evolution.
        

---

## 2. Directory Layout

```text
RVSvKit/
├── common/
│   ├── pkg/
│   │   ├── common_pkg.sv       # types, parameters, macros
│   │   ├── interfaces_pkg.sv   # shared interface helpers
│   │   └── macros_pkg.sv       # utility macros
│   └── utils/
│       └── assertions.sv      # common assertion tasks
├── protocols/
│   ├── tilelink/
│   │   ├── interface/
│   │   │   └── tilelink_if.sv  # TileLink bundle (A/B/C/D/E channels)
│   │   ├── adapters/
│   │   │   ├── tl_to_axi4lite.sv
│   │   │   └── axi4lite_to_tl.sv
│   │   └── tb/
│   └── axi4lite/
│       ├── interface/
│       │   └── axi4lite_if.sv
│       ├── adapters/
│       └── tb/
└── docs/
    └── protocols/
        ├── tilelink.md        # timing diagrams & field mappings
        └── axi4lite.md        # protocol overview & semantics
```

---

## 3. Interface Definition Guidelines

1. **Header Comment**
    
    ```systemverilog
    //-------------------------------------------------------------------------
    // Interface : tilelink_if
    // Version   : 0.1.0
    // Author    : Connie
    // Date      : 2025-06-17
    // Brief     : Bundle for TileLink A/B/C/D/E channels with valid-ready.
    //-------------------------------------------------------------------------
    ```
    
2. **Interface Block**
    
    - Parameterize widths:
        
        ```systemverilog
        interface tilelink_if #(
          parameter int XLEN        = 32,
          parameter int TL_DATA_WIDTH = 64
        ) (input logic clk, input logic rst_n);
          logic valid;
          logic ready;
          logic [7:0] opcode;
          logic [TL_DATA_WIDTH-1:0] data;
          // … other fields …
        endinterface
        ```
        
3. **Adapter Module**
    
    - Import relevant packages:
        
        ```systemverilog
        import common_pkg::*;
        import interfaces_pkg::*;
        ```
        
    - Preserve valid-ready semantics between interfaces.
        

---

## 4. Adapter Field Mapping Table

|Source Field|Dest Field|Conversion Notes|
|---|---|---|
|TL.opcode|AXI.awprot/arprot|Pack opcode bits into prot fields|
|TL.size|AXI.awlen/arlen|Scale from bytes to beat counts|
|TL.source|AXI.arid|Direct map|
|TL.mask|AXI.wstrb|Inverse mapping of byte-mask bits|

---

## 5. Testing Templates

```systemverilog
module tilelink_if_tb;
  // Instantiate interface and simple driver
  tilelink_if #(.TL_DATA_WIDTH(64)) tl_if(clk, rst_n);
  initial begin
    // Cycle through valid-ready handshake
    tl_if.valid <= 1;
    wait (tl_if.ready);
    // … assert data integrity …
  end
endmodule
```

Use similar skeletons for all adapters in `protocols/<bus>/tb/`.

___