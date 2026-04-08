# CCProjects — Claude Code Workspace

**GitHub:** [JannikRoesch/CCProjects](https://github.com/JannikRoesch/CCProjects)
**Owner:** Jannik Roesch (@JannikRoesch)
**Purpose:** Main entrypoint for all Claude Code projects. Every new project lives under `projects/`.

---

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd export > .beads/issues.jsonl
   git add .beads/issues.jsonl && git commit -m "chore: sync beads" --allow-empty-message
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**NOTE:** `bd dolt push` requires a Dolt remote (not configured). Use `bd export > .beads/issues.jsonl && git push` instead for persistence.

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
<!-- END BEADS INTEGRATION -->

---

## Architecture Overview

```
ccprojects/                          ← Root workspace (JannikRoesch/CCProjects on GitHub)
├── .beads/                          # Workspace beads tracker (server mode, Dolt)
│   └── issues.jsonl                 # Exported backup — committed to git
├── .claude/                         # Claude Code settings, hooks, skills, agents
│   ├── settings.json                # Hooks, permissions, model config
│   └── hooks/                       # PreToolUse, PostToolUse, Stop, etc.
├── .github/                         # GitHub Actions, issue templates, PR template
│   └── workflows/                   # CI/CD pipelines
├── docs/                            # Workspace documentation
├── projects/                        # Each subdirectory is an independent git repo
│   ├── registry.json                # Index of all projects
│   ├── BeadsUI/                     # Example: BeadsUI project
│   └── CCPlugin/                    # Claude Code plugin for this workspace
├── scripts/                         # Workspace-level automation
│   ├── new-project.sh               # Scaffold a new project (ALWAYS use this)
│   ├── workspace-status.sh          # Show health of all projects
│   ├── sync-all.sh                  # Push all projects to GitHub
│   └── health-check.sh             # Run bd doctor across all projects
├── shared/                          # Shared configs and git hooks
│   └── hooks/                       # Git hook templates (pre-commit, commit-msg)
├── templates/                       # Project starter templates
│   ├── web-app/                     # React+Vite+TS
│   ├── api/                         # Hono+Node
│   ├── cli/                         # Node CLI
│   ├── python/                      # FastAPI+uv
│   └── fullstack/                   # Monorepo web+api
├── CLAUDE.md                        # ← You are here
├── AGENTS.md                        # Agent-specific instructions
└── .gitattributes                   # LF line endings everywhere
```

---

## Starting a New Session

```bash
# 1. Load context
bd prime

# 2. See what needs work
bd ready

# 3. Check workspace health (after /project-health skill available)
# scripts/workspace-status.sh

# 4. Pick an issue and claim it
bd update <id> --claim
```

## Creating a New Project

```bash
# Basic (blank template)
scripts/new-project.sh my-project-name

# With template
scripts/new-project.sh my-project-name --template=web-app

# With custom beads prefix
scripts/new-project.sh my-project-name --prefix=myprj
```

Each project gets: git repo, beads (server mode), CLAUDE.md, AGENTS.md, .gitignore, .mcp.json.

---

## Available Scripts

| Script | Purpose |
|--------|---------|
| `scripts/new-project.sh <name>` | Scaffold new project under projects/ |
| `scripts/workspace-status.sh` | Show all projects git + beads status |
| `scripts/sync-all.sh` | Export beads + git push for all projects |
| `scripts/health-check.sh` | Run bd doctor across all projects |

## Available Skills (Claude Code)

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `/workspace-status` | "workspace status" | All-projects health dashboard |
| `/new-project` | "create new project" | Interactive project scaffolding |
| `/sync-all` | "sync everything" | Push all projects to GitHub |
| `/daily-standup` | "standup", "what should I work on" | Session start briefing |
| `/switch-project` | "switch to X" | Change active project context |
| `/project-health` | "health check" | Full workspace diagnostics |

## Available Agents

| Agent | Purpose |
|-------|---------|
| `workspace-scout` | Read-only diagnostics across all projects |
| `sync-agent` | Handles git + beads sync autonomously |
| `onboarding-agent` | Guided new project creation |
| `code-review-agent` | Workspace-aware code review |

---

## Conventions & Patterns

### Stack Preferences
- **Web apps:** React 18+ + TypeScript + Vite + Tailwind CSS
- **APIs:** Node.js + Hono + TypeScript
- **Full-stack:** pnpm monorepo (packages/web + packages/api)
- **CLI tools:** Node.js + commander + TypeScript
- **Python projects:** uv + FastAPI + ruff

### Beads Priorities
- P0 = Critical / blocking everything
- P1 = High / current sprint
- P2 = Medium / this week
- P3 = Low / next sprint
- P4 = Backlog

### Commit Messages
Follow Conventional Commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`

### Line Endings
Always LF. See `.gitattributes`. Run `git config core.autocrlf false` on new machines.

### GitHub
- Main repo: [JannikRoesch/CCProjects](https://github.com/JannikRoesch/CCProjects)
- Each project MAY have its own repo under JannikRoesch/<ProjectName>
- Use `gh repo create JannikRoesch/<name>` to create project repos

---

## Build & Test

Per-project — see each `projects/<name>/CLAUDE.md`. Root workspace has no build step.

```bash
# Check all TypeScript projects typecheck
for dir in projects/*/; do
  [ -f "$dir/package.json" ] && (cd "$dir" && pnpm typecheck 2>/dev/null) || true
done
```
