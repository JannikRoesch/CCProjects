#!/usr/bin/env node
// PostToolUse hook — auto-export beads after write operations
// Keeps .beads/issues.jsonl always up to date.

import { execSync } from 'node:child_process'
import { existsSync } from 'node:fs'
import { resolve, dirname } from 'node:path'

const input = JSON.parse(process.env.HOOK_INPUT ?? '{}')
const { tool_name } = input

// Only run after file-writing tools
if (!['Write', 'Edit', 'MultiEdit'].includes(tool_name)) {
  process.exit(0)
}

// Find the beads directory by walking up from CWD
function findBeadsDir(startDir) {
  let dir = startDir
  for (let i = 0; i < 5; i++) {
    const candidate = resolve(dir, '.beads')
    if (existsSync(resolve(candidate, 'config.yaml'))) return dir
    const parent = dirname(dir)
    if (parent === dir) break
    dir = parent
  }
  return null
}

const workspaceRoot = findBeadsDir(process.cwd())
if (!workspaceRoot) process.exit(0)

const jsonlPath = resolve(workspaceRoot, '.beads', 'issues.jsonl')

try {
  execSync(`bd export > "${jsonlPath}"`, {
    cwd: workspaceRoot,
    stdio: ['ignore', 'pipe', 'ignore'],
    timeout: 5000,
  })
} catch {
  // Non-fatal — bd may not be ready
}

process.exit(0)
