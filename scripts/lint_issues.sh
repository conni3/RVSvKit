#!/usr/bin/env bash
set -euo pipefail

# 0. prerequisite checks
if ! command -v yamllint &>/dev/null; then
  echo "❌ yamllint not found. Install via 'sudo apt install yamllint' or 'pip install yamllint'." >&2
  exit 1
fi

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q 'version 4'; then
  echo "❌ yq v4 not found. Install Mike Farah’s yq v4: https://github.com/mikefarah/yq" >&2
  exit 1
fi

# 1. yamllint config (disable missing-document-start)
YLINT_CFG='{extends: default, rules: {line-length: {max: 120}, document-start: {level: disable}}}'

# 2. collect files
if [ "$#" -gt 0 ]; then
  files=("$@")
else
  files=(backlog/wk*/wk*.yml)
fi

# 3. lint loop
for file in "${files[@]}"; do
  echo "🔍 Linting $file …"

  # A) syntax + style
  yamllint -d "$YLINT_CFG" "$file"

  # B) top-level `issues:` check
  yq eval '
    if (kind == "map" and has("issues") and (.issues | kind == "seq"))
    then true
    else error("⛔ Missing or invalid top-level `issues` sequence")
    end
  ' "$file" >/dev/null

  # C) per-issue checks
  count=$(yq eval '.issues | length' "$file")
  for i in $(seq 0 $((count-1))); do
    base=".issues[$i]"

    # required keys
    for key in title body gh_labels fields assignee milestone due_on; do
      yq eval "if $base | has(\"$key\") then true else error(\"⛔ $file::$base missing key '$key'\") end" "$file" >/dev/null
    done

    # gh_labels must be a list
    yq eval "if ($base.gh_labels | kind == \"seq\") then true else error(\"⛔ $file::$base.gh_labels must be a list\") end" "$file" >/dev/null

    # fields must match exactly
    fld=$(yq eval "$base.fields" "$file")
    if ! [[ $fld =~ ^area:[^,]+,priority:(high|medium|low),status:(Todo|In\ Progress|Done)$ ]]; then
      echo "⛔ $file::$base.fields invalid: '$fld'"
      exit 1
    fi
  done

  echo "✅ $file OK"
done
