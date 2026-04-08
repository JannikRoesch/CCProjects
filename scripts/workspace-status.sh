#!/usr/bin/env bash
# workspace-status.sh — show health of all projects in the workspace
set -euo pipefail

WORKSPACE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$WORKSPACE/projects/registry.json"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  CCProjects Workspace Status                             ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Root workspace
echo "── Root Workspace ─────────────────────────────────────────"
cd "$WORKSPACE"
git_status=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
git_ahead=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "?")
bd_stats=$(bd count --status=open 2>/dev/null || echo "?")
echo "  git: ${git_status} uncommitted, ${git_ahead} unpushed | beads open: ${bd_stats}"
echo ""

# Individual projects
echo "── Projects ────────────────────────────────────────────────"
for proj_dir in "$WORKSPACE/projects"/*/; do
  [ -d "$proj_dir" ] || continue
  [ -f "$proj_dir/.beads/config.yaml" ] || [ -f "$proj_dir/package.json" ] || continue

  proj_name="$(basename "$proj_dir")"
  cd "$proj_dir"

  # Git status
  if [ -d ".git" ]; then
    dirty=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
    branch=$(git branch --show-current 2>/dev/null || echo "?")
    git_info="branch=${branch} dirty=${dirty} ahead=${ahead}"
  else
    git_info="(no git)"
  fi

  # Beads status
  if [ -f ".beads/config.yaml" ]; then
    open_issues=$(bd count --status=open 2>/dev/null || echo "?")
    in_progress=$(bd count --status=in_progress 2>/dev/null || echo "?")
    blocked=$(bd count --status=blocked 2>/dev/null || echo "?")
    bd_info="open=${open_issues} in_progress=${in_progress} blocked=${blocked}"
  else
    bd_info="(no beads)"
  fi

  echo "  ● $proj_name"
  echo "    git: $git_info"
  echo "    bd:  $bd_info"
  echo ""
done

echo "── Done ────────────────────────────────────────────────────"
