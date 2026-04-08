---
name: workspace-status
description: Show a health overview of all projects in the CCProjects workspace — git status, beads stats, and any issues needing attention.
triggers:
  - "workspace status"
  - "project overview"
  - "what's going on"
  - "show all projects"
  - "/workspace-status"
---

Run `scripts/workspace-status.sh` from the CCProjects root and present the output as a formatted table.

```bash
cd C:/Users/Admin/ccprojects
bash scripts/workspace-status.sh
```

Then summarize:
- Any projects with dirty git state or unpushed commits → suggest `git push`
- Any projects with blocked beads issues → list the blocked issue IDs
- Any projects with 0 open issues → mark as "idle / ready for new work"

End with a one-line summary: "N projects healthy, M need attention."
