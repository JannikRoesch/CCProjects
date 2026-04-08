# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context.

## Stack

- **Frontend**: React 18 + TypeScript + Vite + Tailwind CSS v4
- **Package Manager**: pnpm
- **Testing**: Vitest + React Testing Library
- **Linting**: ESLint + Prettier

## Build & Test

```bash
pnpm install
pnpm dev        # Start dev server
pnpm build      # Production build
pnpm test       # Run tests
pnpm lint       # Lint + type-check
```

## Conventions

- Components in `src/components/`, pages in `src/pages/`
- Use TypeScript strict mode — no `any` without comment
- Tailwind CSS v4: `@import "tailwindcss"` in CSS, `@tailwindcss/vite` plugin
- TanStack Query for server state, Zustand for client state
