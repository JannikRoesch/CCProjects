# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context.

## Stack

- **Monorepo**: pnpm workspaces
- **Frontend** (`packages/web`): React 18 + TypeScript + Vite + Tailwind CSS v4
- **Backend** (`packages/api`): Hono + Node.js + TypeScript
- **Shared** (`packages/shared`): Types + utilities shared between web and api
- **Testing**: Vitest + React Testing Library
- **Linting**: ESLint + Prettier

## Build & Test

```bash
pnpm install                # Install all workspaces
pnpm dev                    # Start all (web + api concurrently)
pnpm -F web dev             # Start only web
pnpm -F api dev             # Start only api
pnpm build                  # Build all
pnpm test                   # Run all tests
pnpm lint                   # Lint all packages
```

## Conventions

- Shared types live in `packages/shared/src/types/`
- API on port 3001, web dev on port 5173
- TypeScript strict mode + exactOptionalPropertyTypes
- Tailwind CSS v4 with `@tailwindcss/vite` plugin
