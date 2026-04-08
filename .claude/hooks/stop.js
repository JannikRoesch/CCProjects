#!/usr/bin/env node
// Stop hook — enforce session close protocol
// Warns Claude if there are unfinished items before it ends the session.

import { execSync } from 'node:child_process'
import { existsSync } from 'node:fs'
import { resolve } from 'node:path'

const cwd = process.cwd()
const warnings = []

// Check for in-progress beads issues
const beadsDir = resolve(cwd, '.beads')
if (existsSync(resolve(beadsDir, 'config.yaml'))) {
  try {
    const result = execSync('bd list --status=in_progress --json', {
      cwd, stdio: ['ignore', 'pipe', 'ignore'], timeout: 3000,
    }).toString().trim()
    const issues = result ? JSON.parse(result) : []
    if (Array.isArray(issues) && issues.length > 0) {
      warnings.push(`${issues.length} in-progress beads issue(s): ${issues.map(i => i.id).join(', ')}`)
    }
  } catch { /* ok */ }
}

// Check for uncommitted git changes
try {
  const dirty = execSync('git status --short', {
    cwd, stdio: ['ignore', 'pipe', 'ignore'], timeout: 3000,
  }).toString().trim()
  if (dirty) {
    const lineCount = dirty.split('\n').filter(Boolean).length
    warnings.push(`${lineCount} uncommitted git change(s)`)
  }
} catch { /* not a git repo */ }

// Check for unpushed commits
try {
  const ahead = execSync('git rev-list --count @{upstream}..HEAD', {
    cwd, stdio: ['ignore', 'pipe', 'ignore'], timeout: 3000,
  }).toString().trim()
  if (ahead && ahead !== '0') {
    warnings.push(`${ahead} unpushed commit(s) — run: git push`)
  }
} catch { /* no upstream */ }

if (warnings.length === 0) process.exit(0)

// Output reminder to Claude's context
const reminder = [
  '⚠ SESSION CLOSE CHECKLIST — before finishing:',
  ...warnings.map(w => `  • ${w}`),
  '',
  'Run: bd export > .beads/issues.jsonl && git add -A && git commit -m "chore: sync" && git push',
].join('\n')

console.log(JSON.stringify({ message: reminder }))
process.exit(0)
