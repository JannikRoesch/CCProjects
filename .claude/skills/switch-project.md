---
name: switch-project
description: Switch active project context — lists all projects, lets user pick, shows ready queue and git status.
triggers:
  - "switch to"
  - "work on project"
  - "open project"
  - "/switch-project"
---

1. **List available projects** from `projects/registry.json` or `ls projects/`:
   ```bash
   cd C:/Users/Admin/ccprojects
   ls projects/ | grep -v registry.json | grep -v .gitkeep
   ```

2. **Ask which project** to switch to (if not specified in the command).

3. **Switch context:**
   ```bash
   cd C:/Users/Admin/ccprojects/projects/<chosen>
   bd prime
   bd ready
   git status --short
   ```

4. **Report:** Show the project's bd ready queue, in-progress issues, git branch, and any blocked issues. Remind the user they're now working in `projects/<chosen>/`.
