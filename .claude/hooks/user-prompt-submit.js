#!/usr/bin/env node
// UserPromptSubmit hook — inject workspace context into every prompt
// Adds a brief context block so Claude stays oriented after compaction.

import { execSync } from 'node:child_process'
import { existsSync, readFileSync } from 'node:fs'
import { resolve, basename } from 'node:path'

const cwd = process.cwd()
const projectName = basename(cwd)

const lines = []

// Git branch
try {
  const branch = execSync('git branch --show-current', { cwd, stdio: ['ignore', 'pipe', 'ignore'] })
    .toString().trim()
  if (branch) lines.push(`git: ${branch}`)
} catch { /* not a git repo */ }

// Active beads issues
const beadsDir = resolve(cwd, '.beads')
if (existsSync(resolve(beadsDir, 'config.yaml'))) {
  try {
    const inProgress = execSync('bd list --status=in_progress --json', {
      cwd,
      stdio: ['ignore', 'pipe', 'ignore'],
      timeout: 3000,
    }).toString().trim()

    if (inProgress) {
      const issues = JSON.parse(inProgress)
      if (Array.isArray(issues) && issues.length > 0) {
        lines.push(`in_progress: ${issues.map(i => `${i.id} (${i.title.slice(0, 40)})`).join(', ')}`)
      }
    }
  } catch { /* bd not available */ }
}

if (lines.length === 0) process.exit(0)

// Output context block that Claude Code prepends to the prompt
const context = `<workspace-context>project=${projectName} ${lines.join(' | ')}</workspace-context>`
console.log(JSON.stringify({ context }))
process.exit(0)
