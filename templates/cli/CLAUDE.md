# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context.

## Stack

- **Runtime**: Node.js + TypeScript
- **CLI Framework**: Commander.js or Yargs
- **Package Manager**: pnpm
- **Testing**: Vitest
- **Bundling**: tsup (ESM + CJS output)

## Build & Test

```bash
pnpm install
pnpm dev        # Run with tsx (no compile step)
pnpm build      # Bundle with tsup
pnpm test       # Run tests
pnpm lint       # Lint + type-check
```

## Conventions

- Entry point: `src/index.ts` (exports nothing, runs CLI)
- Commands in `src/commands/`, utils in `src/utils/`
- Publish as both ESM and CJS via tsup
- TypeScript strict mode — no `any` without comment
