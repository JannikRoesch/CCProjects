#!/usr/bin/env node
// PreToolUse hook — dangerous command guardrail
// Blocks or warns on destructive operations before execution.

const input = JSON.parse(process.env.HOOK_INPUT ?? '{}')
const { tool_name, tool_input } = input

function block(reason) {
  console.log(JSON.stringify({ action: 'block', message: `🛡 BLOCKED: ${reason}` }))
  process.exit(0)
}

function warn(reason) {
  // Warn but allow — Claude sees the message as context
  console.error(`⚠ WARNING: ${reason}`)
}

if (tool_name === 'Bash') {
  const cmd = (tool_input?.command ?? '').toLowerCase()

  // Hard blocks
  if (/rm\s+-rf\s+(\/|~|\.\.|\*|[a-z]:\\)/.test(cmd)) {
    block('rm -rf on a root/home/wildcard path detected. Use targeted paths.')
  }
  if (/git\s+push\s+--force.*main/.test(cmd)) {
    block('Force push to main branch is not allowed.')
  }
  if (/git\s+push\s+-f.*main/.test(cmd)) {
    block('Force push to main branch is not allowed.')
  }
  if (/curl.*\|\s*(ba)?sh/.test(cmd) || /wget.*\|\s*(ba)?sh/.test(cmd)) {
    block('Piping curl/wget directly to shell is not allowed.')
  }
  if (/drop\s+database|drop\s+table/i.test(cmd)) {
    block('DROP DATABASE/TABLE detected. Use migrations instead.')
  }
  if (/git\s+reset\s+--hard\s+.*main/.test(cmd)) {
    block('git reset --hard on main is not allowed.')
  }

  // Soft warnings (logged to stderr, execution continues)
  if (/rm\s+-rf/.test(cmd)) {
    warn(`rm -rf detected: ${cmd.slice(0, 80)}`)
  }
  if (/git\s+push\s+--force/.test(cmd)) {
    warn('Force push detected — ensure this is intentional')
  }
}

// Allow by default (no output = allow)
process.exit(0)
