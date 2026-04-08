#!/usr/bin/env bash
# new-project.sh — scaffold a new Claude Code project under ccprojects/projects/
# Usage: scripts/new-project.sh <project-name> [--prefix=<bd-prefix>]
#
# Creates:
#   projects/<name>/          git repo
#   projects/<name>/CLAUDE.md
#   projects/<name>/AGENTS.md
#   projects/<name>/.gitignore
#   projects/<name>/.mcp.json
#   beads initialized with given prefix (default: project name slug)

set -euo pipefail

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECTS_DIR="$WORKSPACE_ROOT/projects"

usage() {
  echo "Usage: $0 <project-name> [--prefix=<bd-prefix>]"
  echo ""
  echo "  project-name   Directory name for the new project (e.g. my-api)"
  echo "  --prefix       Beads issue ID prefix (default: derived from name)"
  exit 1
}

# Parse args
PROJECT_NAME=""
BD_PREFIX=""

for arg in "$@"; do
  case "$arg" in
    --prefix=*) BD_PREFIX="${arg#--prefix=}" ;;
    --help|-h)  usage ;;
    -*) echo "Unknown option: $arg"; usage ;;
    *)  PROJECT_NAME="$arg" ;;
  esac
done

[[ -z "$PROJECT_NAME" ]] && usage

# Derive prefix from name if not set (strip hyphens, take first 6 chars)
if [[ -z "$BD_PREFIX" ]]; then
  BD_PREFIX=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9' | cut -c1-6)
fi

PROJECT_DIR="$PROJECTS_DIR/$PROJECT_NAME"

if [[ -d "$PROJECT_DIR" ]]; then
  echo "Error: $PROJECT_DIR already exists." >&2
  exit 1
fi

echo "Creating project: $PROJECT_NAME (beads prefix: $BD_PREFIX)"
echo "Location: $PROJECT_DIR"
echo ""

# ── Create project directory and git repo ────────────────────────────────────
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
git init -q

# ── .gitignore ────────────────────────────────────────────────────────────────
cat > .gitignore << 'EOF'
# Beads / Dolt
.dolt/
*.db
.beads-credential-key

# Node
node_modules/
dist/
.env
.env.local

# Python
__pycache__/
*.pyc
.venv/
*.egg-info/

# OS
.DS_Store
Thumbs.db
EOF

# ── .mcp.json ─────────────────────────────────────────────────────────────────
cat > .mcp.json << 'EOF'
{
  "mcpServers": {
    "beads": {
      "command": "beads-mcp"
    }
  }
}
EOF

# ── CLAUDE.md ─────────────────────────────────────────────────────────────────
cat > CLAUDE.md << EOF
# Project Instructions for AI Agents

## Project: $PROJECT_NAME

_Add a short description of this project here._

## Build & Test

\`\`\`bash
# Add your build and test commands here
\`\`\`

## Architecture Overview

_Add a brief overview of this project's architecture._

## Conventions & Patterns

_Add project-specific conventions here._

## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run \`bd prime\` for full context.

\`\`\`bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
\`\`\`

### Rules
- Use \`bd\` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Use \`bd remember\` for persistent knowledge — do NOT use MEMORY.md files
EOF

# ── AGENTS.md ─────────────────────────────────────────────────────────────────
cat > AGENTS.md << EOF
# Agent Instructions

This project uses **bd** (beads) for issue tracking. Run \`bd prime\` for full workflow context.

## Quick Reference

\`\`\`bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work atomically
bd close <id>         # Complete work
\`\`\`

## Non-Interactive Shell Commands

**ALWAYS use non-interactive flags** to avoid hanging on confirmation prompts:

\`\`\`bash
cp -f source dest    # NOT: cp source dest
mv -f source dest    # NOT: mv source dest
rm -f file           # NOT: rm file
rm -rf directory     # NOT: rm -r directory
\`\`\`
EOF

# ── Initialize beads ──────────────────────────────────────────────────────────
echo "Initializing beads (prefix: $BD_PREFIX)..."
bd init --prefix="$BD_PREFIX" --quiet 2>/dev/null || bd init --prefix="$BD_PREFIX"

# ── Initial commit ────────────────────────────────────────────────────────────
git add -A
git commit -q -m "chore: initialize $PROJECT_NAME project scaffold"

echo ""
echo "✓ Project created: $PROJECT_DIR"
echo "✓ Beads initialized with prefix: $BD_PREFIX"
echo ""
echo "Next steps:"
echo "  cd projects/$PROJECT_NAME"
echo "  bd ready"
