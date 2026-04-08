---
name: new-project
description: Interactively scaffold a new Claude Code project under projects/. Handles template selection, beads init, GitHub repo creation, and registry update.
triggers:
  - "create new project"
  - "scaffold project"
  - "new project"
  - "start a project"
  - "/new-project"
---

Guide the user through creating a new project:

1. **Ask for required info** (if not already provided):
   - Project name (kebab-case, e.g. `my-api`)
   - Brief description (1 sentence)
   - Template: `web-app` | `api` | `cli` | `python` | `fullstack` | `blank`
   - Beads prefix (default: first 6 chars of name)
   - Create GitHub repo? (yes/no)

2. **Scaffold the project:**
   ```bash
   cd C:/Users/Admin/ccprojects
   bash scripts/new-project.sh <name> --template=<template> --prefix=<prefix>
   ```

3. **Create GitHub repo if requested:**
   ```bash
   gh repo create JannikRoesch/<name> --public --description "<description>"
   cd projects/<name>
   git remote add origin https://github.com/JannikRoesch/<name>.git
   git push -u origin main
   ```

4. **Update projects/registry.json** — add entry with name, path, description, beads_prefix, created_at, github_repo.

5. **Create initial beads issues** — ask: "Should I create initial issues for this project?" If yes, create 3-5 starter issues based on the project type.

6. **Report:** Show the new project path, GitHub URL (if created), and `cd projects/<name> && bd ready` to start.
