#!/usr/bin/env python3
"""
scaffold_module.py: Generate a new RTL module skeleton for RVSvKit.
Usage: scaffold_module.py <category> <module_name>
"""

import os
import sys
from datetime import datetime

def make_file(path, content):
    if os.path.exists(path):
        print(f"Skipped existing file: {path}")
        return
    with open(path, "w") as f:
        f.write(content)
    print(f"Created: {path}")

def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <category> <module_name>")
        sys.exit(1)

    category, name = sys.argv[1], sys.argv[2]
    base = os.path.join("modules", category, name)
    src  = os.path.join(base, "src")
    tb   = os.path.join(base, "tb")

    # Create directories
    for d in (src, tb):
        os.makedirs(d, exist_ok=True)
        print(f"Directory ready: {d}")

    today = datetime.now().date()

    # 1. RTL file stub
    rtl = os.path.join(src, f"{name}.sv")
    make_file(rtl, f"""//-------------------------------------------------------------------------
// Module : {name}
// Author : Connie
// Date   : {today}
// Brief  : TODO: Describe {name}
//-------------------------------------------------------------------------
module {name} #(
  // TODO: parameters
) (
  // TODO: ports
);
// TODO: implementation
endmodule
""")

    # 2. Testbench stub
    tb_file = os.path.join(tb, f"{name}_tb.sv")
    make_file(tb_file, f"""`timescale 1ns/1ps
module {name}_tb;
  // Instantiate DUT
  {name} uut (
    // TODO: port mapping
  );

  initial begin
    // TODO: stimulus
    #100 $finish;
  end
endmodule
""")

    # 3. README.md stub
    readme = os.path.join(base, "README.md")
    make_file(readme, f"# Module `{name}`\n\n**Category:** `{category}`\n\n## Overview\n\nTODO: Explain what `{name}` does.\n")

if __name__ == "__main__":
    main()
