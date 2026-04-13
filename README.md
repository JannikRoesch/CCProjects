# CCProjects

A multi-project workspace for AI-assisted development, optimized for Claude Code with Beads issue tracking, workspace automation scripts, and a custom plugin ecosystem.

<!-- STATS_START -->
Projects: 0 | Open issues: 2 | Closed: 55 | Updated: 2026-04-13
<!-- STATS_END -->

## What's Inside

| Directory | Purpose |
|-----------|---------|
| `projects/` | Individual projects (each an independent git repo) |
| `.claude/` | Claude Code config — hooks, skills, agents |
| `scripts/` | Workspace automation (status, sync, health-check, new-project) |
| `docs/` | Workspace guides and references |
| `templates/` | Project starter templates (web-app, api, cli, fullstack, python) |
| `shared/` | Shared git hooks and schemas |
| `.github/` | Issue templates, PR template, CODEOWNERS, CI workflows |
| `.beads/` | Workspace-level issue tracker (Beads/Dolt) |

## Projects

| Name | Description | Stack | Status |
|------|-------------|-------|--------|
| [BeadsUI](projects/BeadsUI/) | WebUI for the Beads issue tracker | React + Hono + TypeScript | Active |
| [CCPlugin](projects/CCPlugin/) | Claude Code workspace plugin | TypeScript + MCP | Active |

## Quick Start

### Prerequisites

- Node.js 18+
- pnpm (`npm i -g pnpm`)
- [Beads (`bd`)](https://github.com/drop-club/beads) — issue tracker CLI
- [GitHub CLI (`gh`)](https://cli.github.com/) — optional, for GitHub integration

### Creating a New Project

```bash
bash scripts/new-project.sh my-project --type=fullstack
```

Or interactively via Claude Code:
```
/new-project
```

### Checking Workspace Health

```bash
bash scripts/workspace-status.sh    # Quick overview
bash scripts/health-check.sh        # Detailed diagnostics
```

### Syncing Everything to GitHub

```bash
bash scripts/sync-all.sh
```

## Claude Code Integration

This workspace is configured for Claude Code with:

### Skills (slash commands)

| Command | Purpose |
|---------|---------|
| `/daily-standup` | Session briefing — closed, in-progress, ready, blocked |
| `/workspace-status` | All-projects health overview |
| `/sync-all` | Push all projects to GitHub |
| `/new-project` | Guided interactive project creation |
| `/switch-project` | Context-aware project switch |
| `/project-health` | Deep diagnostic with remediation guidance |

### Agents

| Agent | Description |
|-------|-------------|
| `workspace-scout` | Read-only diagnostics across all projects |
| `sync-agent` | Git + Beads sync for all projects |
| `onboarding-agent` | Guided new project setup |
| `code-review-agent` | Pre-merge code review (security, commits, architecture) |

### Hooks

| Event | Hook | Purpose |
|-------|------|---------|
| `SessionStart` | `bd prime` | Load beads workflow context |
| `PreCompact` | `bd prime` | Re-prime after context compaction |
| `PreToolUse(Bash)` | `pre-tool-use.js` | Block dangerous commands |
| `PostToolUse(Write/Edit)` | `post-tool-use.js` | Auto-export beads snapshot |
| `Stop` | `stop.js` | Enforce session close protocol |
| `Notification` | `notification.js` | Windows desktop notifications |

## Beads Workflow

```bash
bd ready                    # Find work to do
bd create --title="..." --type=task
bd update <id> --claim      # Start working
bd close <id>               # Done
```

See [docs/beads-workflow.md](docs/beads-workflow.md) for the full guide.

## Session Protocol

Every session ends with:

```bash
bd export > .beads/issues.jsonl   # Snapshot issues
git add -A
git commit -m "chore: session sync"
git push                          # MANDATORY
```

See `CLAUDE.md` for the full mandatory session close protocol.

## CCPlugin

The [CCPlugin](projects/CCPlugin/) packages all workspace hooks, skills, agents, and an MCP server for distribution to other workspaces.

```bash
cd projects/CCPlugin
pnpm install
pnpm build
pnpm install-plugin          # Install to current workspace
node dist/mcp/server.cjs     # Start MCP server
```

## Documentation

- [Workspace Guide](docs/workspace-guide.md)
- [Beads Workflow](docs/beads-workflow.md)
- [Creating a New Project](docs/new-project.md)
- [CLAUDE.md](CLAUDE.md) — AI agent instructions
- [AGENTS.md](AGENTS.md) — Agent behavior guidelines

---

Built with [Claude Code](https://claude.ai/claude-code) + [Beads](https://github.com/drop-club/beads)
