#!/usr/bin/env python3
import os
import sys
from textwrap import dedent

PRIORITY_OPTIONS = ["high", "medium", "low"]
STATUS_OPTIONS = ["Todo", "In Progress", "Done"]

USAGE = """
Usage: python create_issues.py <week-number>
Example: python create_issues.py 3   # creates backlog/wk3/wk3.yml
"""

TEMPLATE = """\
# priority options: {prio_opts}
# status options: {status_opts}

issues:
  - title: ""
    body: |
      - [ ] 
    gh_labels:
      - area:<area>
      - priority:<priority>    # one of {prio_opts}
      - status:<status>        # one of {status_opts}
    fields: area:<area>,priority:<priority>,status:<status>
    assignee: "@me"
    milestone: "Week {wk}: <Milestone Title>"
    due_on: ""   # ISO8601 timestamp, e.g. 2025-06-30T23:59:00Z
"""

def main():
    if len(sys.argv) != 2 or not sys.argv[1].isdigit():
        print(USAGE.strip())
        sys.exit(1)

    wk = sys.argv[1]
    dirpath = os.path.join("backlog")
    filepath = os.path.join(dirpath, f"wk{wk}.yml")

    os.makedirs(dirpath, exist_ok=True)

    content = TEMPLATE.format(
        prio_opts=", ".join(PRIORITY_OPTIONS),
        status_opts=", ".join(STATUS_OPTIONS),
        wk=wk
    )

    with open(filepath, "w", encoding="utf-8") as f:
        f.write(dedent(content))

    print(f"Scaffold created: {filepath}")

if __name__ == "__main__":
    main()
