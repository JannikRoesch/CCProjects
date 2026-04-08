---
name: sync-all
description: Export all beads databases and push all projects (root + projects/) to GitHub. Run at the end of every work session.
triggers:
  - "sync everything"
  - "push all"
  - "sync all projects"
  - "/sync-all"
---

Run the sync-all script to push everything to GitHub:

```bash
cd C:/Users/Admin/ccprojects
bash scripts/sync-all.sh
```

Report:
- Which projects were pushed successfully
- Which failed (and why)
- Total commits pushed

If any project fails, diagnose the error and fix it (merge conflicts, missing remote, etc.) before re-running.
