# Shared Git Hook Templates

Reusable git hook templates for CCProjects projects.

## Available Hooks

| Hook | Purpose |
|------|---------|
| `pre-commit` | Block secrets, .env files; run linter |
| `commit-msg` | Enforce Conventional Commits format |
| `pre-push` | Prevent force-push to main; run tests |

## Installing in a Project

```bash
# From your project root:
cp ../../shared/hooks/pre-commit .git/hooks/pre-commit
cp ../../shared/hooks/commit-msg .git/hooks/commit-msg
cp ../../shared/hooks/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-commit .git/hooks/commit-msg .git/hooks/pre-push
```

Or use the setup script:

```bash
bash ../../scripts/install-hooks.sh
```

## Customizing

Copy the hook to your project's `.git/hooks/` and edit as needed. The templates are intentionally conservative — add your project-specific checks.
