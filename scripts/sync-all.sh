#!/usr/bin/env bash
# sync-all.sh — export beads + git push for root + all projects
set -euo pipefail

WORKSPACE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pass=0
fail=0

sync_project() {
  local dir="$1"
  local name="$2"

  cd "$dir"

  # Export beads if present
  if [ -f ".beads/config.yaml" ]; then
    bd export > .beads/issues.jsonl 2>/dev/null || true
  fi

  # Git sync
  if [ -d ".git" ]; then
    # Check if remote exists
    if git remote get-url origin &>/dev/null; then
      git pull --rebase --autostash 2>/dev/null || true

      # Stage and commit changes if any
      if ! git diff --quiet || ! git diff --staged --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
        git add -A 2>/dev/null || true
        git diff --staged --quiet || git commit -m "chore: auto-sync [$(date -u +%Y-%m-%dT%H:%M:%SZ)]" 2>/dev/null || true
      fi

      git push 2>/dev/null && echo "  ✓ $name pushed" || echo "  ✗ $name push failed"
    else
      echo "  - $name (no remote)"
    fi
  fi
}

echo "Syncing workspace..."
echo ""

# Root
sync_project "$WORKSPACE" "root (CCProjects)" && ((pass++)) || ((fail++))

# Projects
for proj_dir in "$WORKSPACE/projects"/*/; do
  [ -d "$proj_dir" ] || continue
  proj_name="$(basename "$proj_dir")"
  sync_project "$proj_dir" "$proj_name" && ((pass++)) || ((fail++))
done

echo ""
echo "Done: ${pass} synced, ${fail} failed"
