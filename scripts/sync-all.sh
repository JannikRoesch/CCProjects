#!/usr/bin/env bash
# sync-all.sh — export beads + git push for root + all projects
set -uo pipefail

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

      if git push 2>/dev/null; then
        echo "  ✓ $name pushed"
        return 0
      else
        echo "  ✗ $name push failed"
        return 1
      fi
    else
      echo "  - $name (no remote)"
    fi
  fi
}

echo "Syncing workspace..."
echo ""

# Root
if sync_project "$WORKSPACE" "root (CCProjects)"; then
  pass=$((pass + 1))
else
  fail=$((fail + 1))
fi

# Projects
for proj_dir in "$WORKSPACE/projects"/*/; do
  [ -d "$proj_dir" ] || continue
  proj_name="$(basename "$proj_dir")"
  if sync_project "$proj_dir" "$proj_name"; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
  fi
done

echo ""
echo "Done: ${pass} synced, ${fail} failed"
