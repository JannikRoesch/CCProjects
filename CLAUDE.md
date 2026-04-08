# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

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

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->


## Architecture Overview

This is a **multi-project workspace** for Claude Code development.

```
ccprojects/
├── .beads/          # Workspace-level beads issue tracker (Dolt-backed)
├── .claude/         # Workspace-level Claude Code settings & hooks
├── projects/        # Individual Claude Code projects (each is its own git repo)
│   └── <name>/      # Created via: scripts/new-project.sh <name>
├── shared/          # Cross-project configs, hooks, utilities
└── scripts/
    └── new-project.sh  # Scaffold a new project with beads, CLAUDE.md, AGENTS.md
```

### Creating a New Project

```bash
scripts/new-project.sh my-project-name
# Optional: --prefix=myprj  (custom beads issue ID prefix)
```

Each project gets its own git repo, beads instance, CLAUDE.md, and AGENTS.md.

## Build & Test

_Per-project — see each `projects/<name>/CLAUDE.md`_

## Conventions & Patterns

- One beads instance per project (scoped issue IDs)
- Workspace-level beads tracks cross-project work
- Each project is an independent git repo under `projects/`
- `scripts/new-project.sh` is the canonical way to scaffold new projects
