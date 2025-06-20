#!/usr/bin/env python3
"""
scaffold_pkg.py: Generate a new package skeleton for RVSvKit.
Usage: scaffold_pkg.py <package_name> [version]
"""

import os
import sys
from datetime import datetime

def main():
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print(f"Usage: {sys.argv[0]} <package_name> [version]")
        sys.exit(1)

    pkg = sys.argv[1]
    version = sys.argv[2] if len(sys.argv) == 3 else "0.1.0"
    today = datetime.now().date()

    pkg_dir = os.path.join("common", "pkg")
    os.makedirs(pkg_dir, exist_ok=True)

    pkg_file = os.path.join(pkg_dir, f"{pkg}_pkg.sv")
    changelog = os.path.join(pkg_dir, "CHANGELOG.md")

    # 1. Create package file
    if not os.path.exists(pkg_file):
        with open(pkg_file, "w") as f:
            f.write(f"""//-------------------------------------------------------------------------
// Package   : {pkg}_pkg
// Version   : {version}
// Author    : Connie
// Date      : {today}
// Brief     : TODO: Describe `{pkg}_pkg`
//-------------------------------------------------------------------------
package {pkg}_pkg;
  // TODO: types, parameters, macros
endpackage
""")
        print(f"Created: {pkg_file}")
    else:
        print(f"Skipped existing package: {pkg_file}")

    # 2. Update CHANGELOG.md
    if not os.path.exists(changelog):
        with open(changelog, "w") as f:
            f.write("# CHANGELOG\n\n")
        print(f"Initialized: {changelog}")

    with open(changelog, "a") as f:
        f.write(f"- {today}: initialize `{pkg}_pkg` at version {version}\n")
    print(f"Appended changelog entry for `{pkg}_pkg`")

if __name__ == "__main__":
    main()
