#!/usr/bin/env bash
set -euo pipefail

# ================= Configuration =================
# Paste your Project-V2 node ID below:
PROJECT_V2_ID="PVT_kwHOBXWzIc4A8QdW"  # replace with your actual ID

# usage: create_issues.sh path/to/issues.yml [project-number]
if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 path/to/issues.yml [project-number]"
  exit 1
fi
ISSUE_FILE="$1"
PROJECT_NUMBER="${2:-1}"
echo "▶ Using Project #$PROJECT_NUMBER (ID: $PROJECT_V2_ID)"

# check deps
deps=(gh yq jq date)
for cmd in "${deps[@]}"; do
  command -v "$cmd" >/dev/null || { echo "⚠️ $cmd is required"; exit 1; }
done

# Repo info
repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
repo_name=${repo##*/}
owner=${repo%%/*}

# Compute Friday due date
today=$(date +%Y-%m-%d)
weekday=$(date +%u)
if (( weekday <= 5 )); then
  offs=$((5-weekday))
else
  offs=$((12-weekday))
fi
due_date=$(date -d "$today +$offs days" +%Y-%m-%d)
echo "▶ Milestone due date: $due_date"

# 1) Ensure labels exist
labels=$(yq -r '.issues[].labels' "$ISSUE_FILE" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | grep -v '^$' | sort -u)
for lbl in $labels; do
  gh label list --json name --jq '.[].name' | grep -Fxq "$lbl" || {
    echo "➤ Creating label: $lbl"
    gh label create "$lbl" --color ededec --description "auto-generated"
  }
done

# 2) Ensure milestones exist
all_ms=$(gh api "repos/$repo/milestones?state=all")
for m in $(yq -r '.issues[] | select(.milestone) | .milestone' "$ISSUE_FILE" | sort -u); do
  echo "$all_ms" | jq -r --arg T "$m" '.[] | select(.title==$T) | .title' >/dev/null 2>&1 || {
    echo "➤ Creating milestone: $m"
    gh api "repos/$repo/milestones" -f title="$m" -f due_on="${due_date}T23:59:59Z" >/dev/null
  }
done

echo
# 3) Fetch fields by node ID
graphql_query='query($projectId: ID!) {
  node(id: $projectId) {
    ... on ProjectV2 {
      fields(first:50) {
        nodes {
          __typename
          ... on ProjectV2SingleSelectField {
            id
            name
            options {
              id
              name
            }
          }
          ... on ProjectV2Field {
            id
            name
          }
        }
      }
    }
  }
}'
raw_fields=$(gh api graphql -f query="${graphql_query}" -f projectId="$PROJECT_V2_ID")

echo "▶ RAW_FIELDS JSON:"
jq . <<<"$raw_fields"

# Extract the IDs
PRIORITY_FID=$(jq -r '.data.node.fields.nodes[] | select(.name=="Priority") | .id' <<<"$raw_fields")
STATUS_FID=$(jq -r '.data.node.fields.nodes[] | select(.name=="Status")   | .id' <<<"$raw_fields")
AREA_FID=$(jq -r '.data.node.fields.nodes[]   | select(.name=="area")     | .id' <<<"$raw_fields")
echo "▶ Field IDs: Priority=$PRIORITY_FID, Status=$STATUS_FID, area(text)=$AREA_FID"

# Build option maps
declare -A priority_opts
declare -A status_opts

# Populate Priority options
while read -r name id; do
  priority_opts["$name"]="$id"
done < <(
  jq -r '.data.node.fields.nodes[] | select(.name=="Priority") | .options[] | "\(.name) \(.id)"' <<<"$raw_fields"
)

# Populate Status options
while read -r name id; do
  status_opts["$name"]="$id"
done < <(
  jq -r '.data.node.fields.nodes[] | select(.name=="Status") | .options[] | "\(.name) \(.id)"' <<<"$raw_fields"
)
echo "▶ Options: ${#priority_opts[@]} priority, ${#status_opts[@]} status"
echo

# 4) Loop through issues
count=$(yq -r '.issues | length' "$ISSUE_FILE")
for ((i=0;i<count;i++)); do
  title=$(yq -r ".issues[$i].title" "$ISSUE_FILE")
  body=$(yq -r  ".issues[$i].body"  "$ISSUE_FILE")
  assignee=$(yq -r ".issues[$i].assignee" "$ISSUE_FILE")
  milestone=$(yq -r ".issues[$i].milestone // \"\"" "$ISSUE_FILE")
  labels_csv=$(yq -r ".issues[$i].labels // \"\"" "$ISSUE_FILE")

  # create the issue
  cmd=(gh issue create --title "$title" --body "$body" --assignee "$assignee")
  [[ -n "$milestone" ]] && cmd+=(--milestone "$milestone")
  issue_url="$("${cmd[@]}")"
  issue_num=${issue_url##*/}
  echo "✔ Issue #$issue_num created"

  # fetch its node ID
  ISSUE_ID=$(gh api graphql -f query='query { repository(owner:"'"$owner"'", name:"'"$repo_name"'") { issue(number:'"$issue_num"') { id } } }' | jq -r '.data.repository.issue.id')

  # add to project
  ITEM_ID=$(gh api graphql -f query='mutation { addProjectV2ItemById(input:{projectId:"'"$PROJECT_V2_ID"'", contentId:"'"$ISSUE_ID"'"}) { item { id } } }' | jq -r '.data.addProjectV2ItemById.item.id')
  echo "✔ Added to project (item $ITEM_ID)"

  # set all fields
declare -A fv
  IFS=',' read -ra parts <<< "$labels_csv"
  for part in "${parts[@]}"; do
    key=${part%%:*}
    val=${part#*:}
    case "$key" in
      priority)
        opt_id=${priority_opts[$val]}
        gh api graphql -f query='mutation { updateProjectV2ItemFieldValue(input:{projectId:"'"$PROJECT_V2_ID"'", itemId:"'"$ITEM_ID"'", fieldId:"'"$PRIORITY_FID"'", value:{ singleSelectOptionId:"'"$opt_id"'" }}) { projectV2Item { id } } }' >/dev/null
        fv[priority]="$val"
        ;;
      status)
        opt_id=${status_opts[$val]}
        gh api graphql -f query='mutation { updateProjectV2ItemFieldValue(input:{projectId:"'"$PROJECT_V2_ID"'", itemId:"'"$ITEM_ID"'", fieldId:"'"$STATUS_FID"'", value:{ singleSelectOptionId:"'"$opt_id"'" }}) { projectV2Item { id } } }' >/dev/null
        fv[status]="$val"
        ;;
      area)
        gh api graphql -f query='mutation { updateProjectV2ItemFieldValue(input:{projectId:"'"$PROJECT_V2_ID"'", itemId:"'"$ITEM_ID"'", fieldId:"'"$AREA_FID"'", value:{ text:"'"$val"'" }}) { projectV2Item { id } } }' >/dev/null
        fv[area]="$val"
        ;;
    esac
done

  echo "✔ Fields set: priority=${fv[priority]:-}, status=${fv[status]:-}, area=${fv[area]:-}"
  echo
done
echo "🎉 All done!"
