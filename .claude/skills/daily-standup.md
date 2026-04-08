---
name: daily-standup
description: Generate a session-start briefing across all workspace projects — recently closed issues, in-progress work, top ready items, and blocked issues. Use at the start of every work session.
triggers:
  - "standup"
  - "what should I work on"
  - "session start"
  - "morning briefing"
  - "/daily-standup"
---

Generate a concise daily standup for the CCProjects workspace.

Run the following and present results as a formatted briefing:

```bash
# 1. Root workspace status
cd C:/Users/Admin/ccprojects

echo "=== WORKSPACE STANDUP $(date +%Y-%m-%d) ==="
echo ""

echo "--- Recently Closed (last 24h) ---"
bd list --status=closed --json 2>/dev/null | node -e "
const d = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
const cutoff = Date.now() - 86400000;
d.filter(i => new Date(i.closed_at||i.updated_at).getTime() > cutoff)
 .forEach(i => console.log('  ✓', i.id, i.title));
" 2>/dev/null || echo "  (none)"

echo ""
echo "--- In Progress ---"
bd list --status=in_progress 2>/dev/null || echo "  (none)"

echo ""
echo "--- Ready to Work (P0/P1) ---"
bd ready 2>/dev/null | head -8 || echo "  (none)"

echo ""
echo "--- Blocked ---"
bd blocked 2>/dev/null || echo "  (none)"
```

Then for each project in `projects/`:
- Show project name + bd stats (open/in_progress/blocked)
- Highlight any blocked or P0 issues

End with: "**Recommended next action:** [the single most important thing to work on]"
