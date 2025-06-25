#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# delete_issues.sh — delete a range of GitHub issues
# Usage: ./delete_issues.sh START END
# -------------------------------------------------

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <start_issue_number> <end_issue_number>" >&2
  exit 1
fi

START=$1
END=$2

# Make sure gh is installed
command -v gh >/dev/null 2>&1 || {
  echo "⚠️  GitHub CLI (gh) is required but not found." >&2
  exit 1
}

# Figure out current repo (OWNER/REPO)
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

echo "▶ Deleting issues #$START through #$END in $REPO"
for num in $(seq "$START" "$END"); do
  echo "  ↪ Deleting issue #$num …"
  gh issue delete "$num" \
    --repo "$REPO" \
    --yes           # skip confirmation prompts
done

echo "✅ Done deleting issues #$START–#$END"
