# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context.

## Stack

- **Framework**: Hono + Node.js + TypeScript
- **Package Manager**: pnpm
- **Testing**: Vitest
- **Linting**: ESLint + Prettier

## Build & Test

```bash
pnpm install
pnpm dev        # Start dev server (tsx watch)
pnpm build      # Compile TypeScript
pnpm test       # Run tests
pnpm lint       # Lint + type-check
```

## Conventions

- Routes in `src/routes/`, middleware in `src/middleware/`
- Use `@hono/node-server` for Node.js adapter
- Return JSON with consistent shape: `{ data, error, meta }`
- Validate request bodies with Zod
- TypeScript strict mode — no `any` without comment
