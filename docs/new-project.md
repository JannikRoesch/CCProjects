# Creating a New Project

## Quick Start

```bash
bash scripts/new-project.sh my-project-name
```

Or use the interactive skill in Claude Code:
```
/new-project
```

## Script Options

```bash
bash scripts/new-project.sh <name> [options]

Options:
  --type=<type>     Project type: web-app, api, cli, python, fullstack, blank (default: blank)
  --prefix=<str>    Beads issue prefix (default: first 6 chars of name)
  --no-git          Skip git initialization
  --no-beads        Skip beads initialization
```

## What Gets Created

```
projects/<name>/
├── .beads/
│   ├── config.yaml       # Beads config (server mode, Windows-safe)
│   └── issues.jsonl      # Beads snapshot for git backup
├── .gitignore            # Language-appropriate ignores
├── CLAUDE.md             # AI agent instructions (pre-filled)
└── README.md             # Project README
```

Plus a git repository is initialized and the project is registered in `projects/registry.json`.

## Adding to GitHub

After creating:

```bash
cd projects/<name>
gh repo create JannikRoesch/<name> --public --description "Your description"
git remote add origin https://github.com/JannikRoesch/<name>.git
git push -u origin main
```

Or ask the onboarding-agent:
> "Create a GitHub repo for my-project-name"

## Project Types

| Type | Stack Suggestions |
|------|------------------|
| `web-app` | React + Vite + Tailwind + TypeScript |
| `api` | Hono + Node.js + TypeScript |
| `cli` | TypeScript + Commander.js |
| `python` | Python 3.11+ + uv + ruff |
| `fullstack` | React + Hono + pnpm workspaces |
| `blank` | Empty project, no stack assumptions |
| `plugin` | Claude Code plugin structure |

## After Creation

1. `cd projects/<name>`
2. Run `/daily-standup` to see your ready queue
3. Create initial beads issues for your project
4. Start building!
