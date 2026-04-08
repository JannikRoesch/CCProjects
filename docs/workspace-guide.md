# CCProjects Workspace Guide

## Overview

CCProjects is a multi-project workspace for AI-assisted development. Each project under `projects/` is an independent git repository managed by Claude Code.

## Directory Structure

```
ccprojects/
├── .beads/              # Workspace-level issue tracker (beads/dolt)
├── .claude/
│   ├── agents/          # Specialized sub-agents
│   ├── hooks/           # Event hooks (PreToolUse, PostToolUse, Stop, etc.)
│   ├── skills/          # Slash command shortcuts
│   └── settings.json    # Hook registrations & permissions
├── docs/                # This directory — workspace documentation
├── projects/            # One subdirectory per project (each its own git repo)
│   └── registry.json    # Project index
├── scripts/             # Workspace automation scripts
├── shared/              # Shared utilities, schemas, git hook templates
│   └── hooks/           # Reusable git hooks for projects
├── templates/           # Project scaffolding templates
├── AGENTS.md            # Agent behavior guidelines
├── CLAUDE.md            # AI agent instructions (this workspace)
└── .gitignore           # Ignores projects/* subdirectories
```

## Working with Projects

### Creating a New Project

```bash
bash scripts/new-project.sh <name> [--type=web-app|api|cli|python|fullstack|blank]
```

Or use the `/new-project` skill in Claude Code for interactive guided setup.

### Switching Between Projects

```bash
cd projects/<name>
```

Or use `/switch-project` skill to get context-aware handoff.

### Workspace Health

```bash
bash scripts/workspace-status.sh    # Quick status of all projects
bash scripts/health-check.sh        # Detailed diagnostics
```

## Beads Issue Tracker

Each project has its own beads tracker. The workspace root also has one for cross-cutting concerns.

```bash
# In any project or workspace root:
bd ready              # Find available work
bd create             # Create new issue
bd stats              # Project statistics
```

See [beads-workflow.md](./beads-workflow.md) for the full workflow guide.

## Session Protocol

**Starting a session:**
1. Run `/daily-standup` to get context
2. Run `bd ready` to see available work
3. Claim work with `bd update <id> --claim`

**Ending a session:**
1. Close completed issues: `bd close <id1> <id2> ...`
2. Export beads: `bd export > .beads/issues.jsonl`
3. Commit and push: `git add -A && git commit -m "..." && git push`

See CLAUDE.md for the mandatory session close protocol.

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `scripts/new-project.sh <name>` | Scaffold a new project |
| `scripts/workspace-status.sh` | Show all project statuses |
| `scripts/sync-all.sh` | Sync all projects to GitHub |
| `scripts/health-check.sh` | Diagnostic check across workspace |

## Skills Reference

| Skill | Trigger | Purpose |
|-------|---------|---------|
| Daily Standup | `/daily-standup` | Session briefing |
| Workspace Status | `/workspace-status` | All-projects health overview |
| Sync All | `/sync-all` | Push all projects to GitHub |
| New Project | `/new-project` | Interactive project creation |
| Switch Project | `/switch-project` | Context-aware project switch |
| Project Health | `/project-health` | Diagnostic deep-dive |

## Agents Reference

| Agent | Description |
|-------|-------------|
| `workspace-scout` | Read-only diagnostics, never writes |
| `sync-agent` | Git + beads sync across all projects |
| `onboarding-agent` | Guided new project creation |
| `code-review-agent` | Pre-merge code review checks |
