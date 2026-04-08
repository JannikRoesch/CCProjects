#!/usr/bin/env bash
# health-check.sh — run diagnostics across all workspace projects
set -euo pipefail

WORKSPACE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

issues_found=0

check_project() {
  local dir="$1"
  local name="$2"
  local proj_issues=0

  cd "$dir"
  echo "── $name ────────────────────────────────────────────────"

  # Git checks
  if [ -d ".git" ]; then
    # Unpushed commits
    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
    if [ "$ahead" -gt 0 ]; then
      echo "  ⚠ $ahead unpushed commit(s)"
      ((proj_issues++))
    fi

    # Uncommitted changes
    dirty=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
    if [ "$dirty" -gt 0 ]; then
      echo "  ⚠ $dirty uncommitted change(s)"
      ((proj_issues++))
    fi
  fi

  # Beads checks
  if [ -f ".beads/config.yaml" ]; then
    blocked=$(bd count --status=blocked 2>/dev/null || echo "0")
    if [ "$blocked" -gt 0 ]; then
      echo "  ⚠ $blocked blocked issue(s)"
      ((proj_issues++))
    fi

    # Stale issues
    stale_count=$(bd stale 2>/dev/null | grep -c "^○\|^◐" || echo "0")
    if [ "$stale_count" -gt 0 ]; then
      echo "  ⚠ $stale_count stale issue(s)"
      ((proj_issues++))
    fi
  fi

  # CLAUDE.md check
  if [ ! -f "CLAUDE.md" ]; then
    echo "  ✗ Missing CLAUDE.md"
    ((proj_issues++))
  fi

  if [ "$proj_issues" -eq 0 ]; then
    echo "  ✓ All checks passed"
  fi

  echo ""
  return $proj_issues
}

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  CCProjects Health Check                                 ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

check_project "$WORKSPACE" "root" || ((issues_found += $?)) || true

for proj_dir in "$WORKSPACE/projects"/*/; do
  [ -d "$proj_dir" ] || continue
  proj_name="$(basename "$proj_dir")"
  check_project "$proj_dir" "$proj_name" || ((issues_found += $?)) || true
done

if [ "$issues_found" -eq 0 ]; then
  echo "✓ Workspace is healthy"
else
  echo "⚠ $issues_found issue(s) found — review above"
  exit 1
fi
