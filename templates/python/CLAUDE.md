# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context.

## Stack

- **Language**: Python 3.11+
- **Package Manager**: uv (not pip, not poetry)
- **Linting**: ruff (lint + format, replaces black/flake8/isort)
- **Testing**: pytest
- **Type checking**: mypy or pyright

## Build & Test

```bash
uv sync                     # Install dependencies
uv run python -m <package>  # Run
uv run pytest               # Tests
uv run ruff check .         # Lint
uv run ruff format .        # Format
uv run mypy .               # Type check
```

## Conventions

- Use `pyproject.toml` (not setup.py/requirements.txt)
- `uv` for all package management
- Type annotations on all public functions
- ruff for linting and formatting (no black, no flake8)
