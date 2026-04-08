# Beads Workflow Guide

## What is Beads?

Beads (`bd`) is a local-first issue tracker backed by Dolt (a version-controlled MySQL-compatible database). It's designed for AI-assisted development workflows.

## Installation

Beads is pre-installed at the workspace level. Each project initializes its own beads store.

```bash
bd --version    # Check version
bd doctor       # Check health
```

## Core Concepts

### Issue Types

| Type | Use for |
|------|---------|
| `task` | General work items |
| `feature` | New functionality |
| `bug` | Defects to fix |
| `epic` | Large initiatives (parent of many tasks) |
| `chore` | Maintenance, refactoring, docs |
| `decision` | Architectural decisions to record |

### Priority Levels

| Level | Label | Meaning |
|-------|-------|---------|
| `0` | P0 | Critical / blocking release |
| `1` | P1 | High / sprint priority |
| `2` | P2 | Medium / normal |
| `3` | P3 | Low / nice to have |
| `4` | P4 | Backlog |

### Issue Lifecycle

```
open → in_progress → closed
         ↑               ↓
      claimed        (suggest-next)
```

## Daily Workflow

### Finding Work

```bash
bd ready                    # Issues with no blockers
bd list --status=open       # All open issues
bd list --status=in_progress  # Your active work
bd blocked                  # Blocked issues (see what's blocking)
```

### Creating Issues

```bash
# Minimal
bd create --title="Fix login redirect" --type=bug

# Full
bd create \
  --title="Implement user preferences" \
  --description="Why this exists and what needs to be done" \
  --type=feature \
  --priority=2 \
  --acceptance="User can save theme and language preferences" \
  --design="Use localStorage for persistence; no server-side storage needed"
```

### Working on Issues

```bash
bd update <id> --claim          # Mark in_progress and assign to you
bd show <id>                    # Full issue details
bd update <id> --notes="..."    # Add progress notes
```

### Closing Work

```bash
bd close <id>                                   # Mark complete
bd close <id1> <id2> <id3>                     # Close multiple at once
bd close <id> --reason="Closed, won't fix"     # With reason
bd close <id> --suggest-next                   # Show newly unblocked issues
```

## Dependencies

```bash
# A depends on B (B must be done first)
bd dep add <A> <B>

# Example: tests depend on the feature being implemented
bd create --title="Implement auth" --type=feature   # → auth-id
bd create --title="Write auth tests" --type=task    # → tests-id
bd dep add tests-id auth-id                        # tests blocked by auth
```

## Epics (Parent-Child)

Use epics to group related work:

```bash
bd create --title="EPIC: User Management" --type=epic   # → epic-id
bd create --title="User registration" --type=feature --parent=epic-id
bd create --title="Password reset" --type=feature --parent=epic-id
bd create --title="Profile editing" --type=feature --parent=epic-id
```

## Hygiene Commands

```bash
bd stale        # Issues with no recent activity
bd orphans      # Issues with broken dependencies
bd lint         # Check for missing descriptions/acceptance criteria
bd stats        # Open/closed/blocked counts
bd preflight    # Pre-PR checks (stale, orphans, blocked)
```

## Git Integration

Beads auto-commits to its internal Dolt database. To back up via git:

```bash
bd export > .beads/issues.jsonl     # Export snapshot
git add .beads/issues.jsonl
git commit -m "chore: sync beads snapshot"
git push
```

> Note: `bd dolt push` requires a Dolt remote (not configured by default). Use the export approach above.

## Windows Notes

- Beads runs in server mode on Windows (no CGO/embedded Dolt)
- The shared Dolt server runs on port 3308
- Each project uses port 22678 with `dolt.shared-server: false`
- If beads fails to start, check: `netstat -ano | grep 3308`
