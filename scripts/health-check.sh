#!/usr/bin/env bash
# health-check.sh — run diagnostics across all workspace projects
set -uo pipefail

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
      proj_issues=$((proj_issues + 1))
    fi

    # Uncommitted changes
    dirty=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
    if [ "$dirty" -gt 0 ]; then
      echo "  ⚠ $dirty uncommitted change(s)"
      proj_issues=$((proj_issues + 1))
    fi
  fi

  # Beads checks
  if [ -f ".beads/config.yaml" ]; then
    blocked_output=$(bd blocked 2>/dev/null || true)
    if echo "$blocked_output" | grep -q "No blocked\|0 blocked\|Total: 0"; then
      blocked=0
    else
      blocked=$(echo "$blocked_output" | grep -cE "^\s*[a-z]+-[a-z0-9]+" 2>/dev/null || echo 0)
      blocked=$(echo "$blocked" | head -1 | tr -d ' ')
      blocked=${blocked:-0}
    fi
    if [ "$blocked" -gt 0 ]; then
      echo "  ⚠ $blocked blocked issue(s)"
      proj_issues=$((proj_issues + 1))
    fi

    # Stale issues
    stale_output=$(bd stale 2>/dev/null || true)
    if echo "$stale_output" | grep -q "No stale issues"; then
      stale_count=0
    else
      stale_count=$(echo "$stale_output" | grep -cE "^\s*(open|in_progress|○|◐)" 2>/dev/null || echo 0)
      stale_count=$(echo "$stale_count" | head -1 | tr -d ' ')
      stale_count=${stale_count:-0}
    fi
    if [ "$stale_count" -gt 0 ]; then
      echo "  ⚠ $stale_count stale issue(s)"
      proj_issues=$((proj_issues + 1))
    fi
  fi

  # CLAUDE.md check
  if [ ! -f "CLAUDE.md" ]; then
    echo "  ✗ Missing CLAUDE.md"
    proj_issues=$((proj_issues + 1))
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

check_project "$WORKSPACE" "root" || issues_found=$((issues_found + $?))

for proj_dir in "$WORKSPACE/projects"/*/; do
  [ -d "$proj_dir" ] || continue
  # Skip directories without a git repo (e.g. partially deleted test projects)
  [ -d "$proj_dir/.git" ] || continue
  proj_name="$(basename "$proj_dir")"
  check_project "$proj_dir" "$proj_name" || issues_found=$((issues_found + $?))
done

if [ "$issues_found" -eq 0 ]; then
  echo "✓ Workspace is healthy"
else
  echo "⚠ $issues_found issue(s) found — review above"
  exit 1
fi
