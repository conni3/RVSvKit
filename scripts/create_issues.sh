#!/usr/bin/env bash
#!/usr/bin/env bash
set -euo pipefail
set -x                                  # ← enable tracing
trap 'echo "❌ ERROR at line $LINENO: $BASH_COMMAND"' ERR

# ================= Configuration =================
PROJECT_V2_ID="PVT_kwHOBXWzIc4A8QdW"   # ← your Project-V2 node ID

# ================ CLI arguments =================
if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 path/to/issues.yml [project-number]" >&2
  exit 1
fi
ISSUE_FILE="$1"
PROJECT_NUMBER="${2:-1}"
echo "▶ Using Project #$PROJECT_NUMBER (ID: $PROJECT_V2_ID)"

# ================ Dependencies ==================
for cmd in gh yq jq date; do
  command -v "$cmd" >/dev/null || { echo "⚠️ $cmd is required"; exit 1; }
done

# ================= Repo info ====================
repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
repo_name=${repo##*/}
owner=${repo%%/*}

# =========== Compute Friday due date ============
weekday=$(date +%u)
offset=$(( (weekday <= 5 ? 5 : 12) - weekday ))
due_date=$(date -d "+$offset days" +%Y-%m-%d)
echo "▶ Milestone due date: $due_date"

echo "🔍 DEBUG: entering label-creation block"
echo "🔍 RAW GH_LABELS: $(yq -r '.issues[].gh_labels[]?' "$ISSUE_FILE" || echo '<none>')"
echo "🔍 RAW FIELDS CSV: $(yq -r '.issues[].fields // ""' "$ISSUE_FILE" || echo '<none>')"


# =========== 1) Ensure GH issue labels exist ============
gh_labels=$( yq -r '.issues[].gh_labels[]?' "$ISSUE_FILE" | sort -u )
for lbl in $gh_labels; do
  gh label list --json name --jq '.[].name' | grep -Fxq "$lbl" || {
    echo "➤ Creating GH label: $lbl"
    gh label create "$lbl" --color ededec --description "auto-generated"
  }
done

# ========== 2) Ensure milestones exist ============
all_ms=$(gh api "repos/$repo/milestones?state=all")
mapfile -t ms_list < <(
  yq -r '.issues[] | select(.milestone) | .milestone' "$ISSUE_FILE" | sort -u
)
for m in "${ms_list[@]}"; do
  [[ -z $m ]] && continue
  if ! printf '%s\n' "$all_ms" | jq -e --arg T "$m" '.[] | select(.title==$T)' >/dev/null; then
    echo "➤ Creating milestone: $m"
    gh api "repos/$repo/milestones" \
       -f title="$m" \
       -f due_on="${due_date}T23:59:59Z" >/dev/null
  fi
done

# ======== 3) Fetch ProjectV2 field + option IDs ===========
# new:
graphql_query=$(cat <<'EOF'
query($projectId: ID!) {
  node(id: $projectId) {
    ... on ProjectV2 {
      fields(first:50) {
        nodes {
          __typename

          # for single‐select fields (Priority, Status, etc.)
          ... on ProjectV2SingleSelectField {
            id
            name
            options {
              id
              name
            }
          }

          # for any other field (text, date, etc.)
          ... on ProjectV2Field {
            id
            name
          }
        }
      }
    }
  }
}
EOF
)


raw_fields=$(gh api graphql -f query="$graphql_query" -f projectId="$PROJECT_V2_ID")

echo "▶ Fetched ProjectV2 fields for ID $PROJECT_V2_ID"
echo "$raw_fields" | jq -r '.data.node.fields.nodes[] | "\(.name) \(.id)"'

# extract field-IDs
PRIORITY_FID=$(jq -r '.data.node.fields.nodes[] | select(.name=="Priority") | .id' <<<"$raw_fields")
STATUS_FID=$(jq -r '.data.node.fields.nodes[] | select(.name=="Status")   | .id' <<<"$raw_fields")
AREA_FID=$(jq -r '.data.node.fields.nodes[]   | select(.name=="area")     | .id' <<<"$raw_fields")

# build option maps
declare -A priority_opts status_opts
while read -r name id; do priority_opts["$name"]="$id"; done < <(
  jq -r '.data.node.fields.nodes[]
         | select(.name=="Priority")
         | .options[]
         | "\(.name) \(.id)"' <<<"$raw_fields"
)
while read -r name id; do status_opts["$name"]="$id"; done < <(
  jq -r '.data.node.fields.nodes[]
         | select(.name=="Status")
         | .options[]
         | "\(.name) \(.id)"' <<<"$raw_fields"
)

echo "▶ Found ProjectV2 fields:"
echo "  - Priority: ${!priority_opts[*]}"
echo "  - Status:   ${!status_opts[*]}"

# ======== 4) Loop through issues ===========
count=$(yq -r '.issues | length' "$ISSUE_FILE")
for ((i = 0; i < count; i++)); do
  title=$(yq -r ".issues[$i].title" "$ISSUE_FILE")
  body=$(yq -r  ".issues[$i].body"  "$ISSUE_FILE")
  assignee=$(yq -r ".issues[$i].assignee" "$ISSUE_FILE")
  milestone=$(yq -r ".issues[$i].milestone // \"\"" "$ISSUE_FILE")
  # collect per-issue GH labels
  mapfile -t issue_gh_labels < <(
    yq -r ".issues[$i].gh_labels[]?" "$ISSUE_FILE"
  )
  # collect ProjectV2 field settings
  fields_csv=$(yq -r ".issues[$i].fields // \"\"" "$ISSUE_FILE")

  # --- create issue
  cmd=(gh issue create --title "$title" --body "$body")
  for lbl in "${issue_gh_labels[@]}"; do
    cmd+=(--label "$lbl")
  done
  [[ -n "$assignee"   ]] && cmd+=(--assignee "$assignee")
  [[ -n "$milestone"  ]] && cmd+=(--milestone "$milestone")
  issue_url=$("${cmd[@]}")
  echo "✔ Issue created: $issue_url"
  issue_num=${issue_url##*/}

  # --- add to project
  ISSUE_ID=$(gh api graphql \
    -f query="query { repository(owner:\"$owner\",name:\"$repo_name\") { issue(number:$issue_num) { id } } }" \
    | jq -r '.data.repository.issue.id')
  ITEM_ID=$(gh api graphql \
    -f query="mutation { addProjectV2ItemById(input:{projectId:\"$PROJECT_V2_ID\",contentId:\"$ISSUE_ID\"}) { item { id } } }" \
    | jq -r '.data.addProjectV2ItemById.item.id')
  echo "✔ Added to project (item $ITEM_ID)"

  # --- set ProjectV2 fields
  declare -A fv
  IFS=',' read -ra parts <<<"$fields_csv"
  for part in "${parts[@]}"; do
    key=${part%%:*}
    val=${part#*:}
    case "$key" in
      priority)
        opt_id=${priority_opts[$val]:-}
        if [[ -z $opt_id ]]; then
          echo "⚠️ Unknown priority '$val' (valid: ${!priority_opts[*]})"
          exit 1
        fi
        gh api graphql \
          -f query="mutation { updateProjectV2ItemFieldValue(input:{projectId:\"$PROJECT_V2_ID\",itemId:\"$ITEM_ID\",fieldId:\"$PRIORITY_FID\",value:{singleSelectOptionId:\"$opt_id\"}}) { projectV2Item { id } } }" \
          >/dev/null
        fv[priority]="$val"
        ;;
      status)
        opt_id=${status_opts[$val]:-}
        if [[ -z $opt_id ]]; then
          echo "⚠️ Unknown status '$val' (valid: ${!status_opts[*]})"
          exit 1
        fi
        gh api graphql \
          -f query="mutation { updateProjectV2ItemFieldValue(input:{projectId:\"$PROJECT_V2_ID\",itemId:\"$ITEM_ID\",fieldId:\"$STATUS_FID\",value:{singleSelectOptionId:\"$opt_id\"}}) { projectV2Item { id } } }" \
          >/dev/null
        fv[status]="$val"
        ;;
      area)
        gh api graphql \
          -f query="mutation { updateProjectV2ItemFieldValue(input:{projectId:\"$PROJECT_V2_ID\",itemId:\"$ITEM_ID\",fieldId:\"$AREA_FID\",value:{text:\"$val\"}}) { projectV2Item { id } } }" \
          >/dev/null
        fv[area]="$val"
        ;;
      *)
        echo "⚠️ Unrecognized field key '$key' – skipping"
        ;;
    esac
  done

  echo "✔ Fields set: priority=${fv[priority]:-}, status=${fv[status]:-}, area=${fv[area]:-}"
done

echo "🎉 All done!"
