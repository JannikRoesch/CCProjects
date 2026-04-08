---
name: project-health
description: Run full diagnostics across all workspace projects — bd doctor, stale issues, orphans, git health.
triggers:
  - "health check"
  - "diagnose workspace"
  - "check for issues"
  - "/project-health"
---

Run the health check script:

```bash
cd C:/Users/Admin/ccprojects
bash scripts/health-check.sh
```

For any issues found:
- **Blocked issues** → show the blocking chain (`bd show <id>`) and suggest unblocking steps
- **Stale issues** → ask if they should be deferred (`bd defer <id> --until="next week"`) or closed
- **Uncommitted changes** → suggest committing and pushing
- **Missing CLAUDE.md** → create one using the template from scripts/new-project.sh

End with a prioritized action list sorted by severity.
