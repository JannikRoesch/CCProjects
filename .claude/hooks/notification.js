#!/usr/bin/env node
/**
 * Notification hook — beads-aware desktop notifications
 * Triggered by: Claude Code Notification event
 *
 * Sends a Windows toast notification when Claude Code has a notification,
 * enriched with any active beads issue context.
 */

const { execSync } = require('child_process');

function getActiveIssue() {
  try {
    const output = execSync('bd list --status=in_progress --format=json 2>/dev/null', {
      cwd: process.cwd(),
      timeout: 3000,
      encoding: 'utf8',
    });
    const issues = JSON.parse(output || '[]');
    if (issues.length > 0) {
      return `${issues[0].id}: ${issues[0].title}`;
    }
  } catch {
    // bd not available or no issues
  }
  return null;
}

function sendWindowsNotification(title, message) {
  // Use PowerShell to send a Windows toast notification
  const ps = `
    Add-Type -AssemblyName System.Windows.Forms
    $notify = New-Object System.Windows.Forms.NotifyIcon
    $notify.Icon = [System.Drawing.SystemIcons]::Information
    $notify.Visible = $true
    $notify.ShowBalloonTip(5000, '${title.replace(/'/g, "''")}', '${message.replace(/'/g, "''")}', [System.Windows.Forms.ToolTipIcon]::Info)
    Start-Sleep -Milliseconds 5500
    $notify.Dispose()
  `.trim();

  try {
    execSync(`powershell.exe -NoProfile -NonInteractive -Command "${ps}"`, {
      timeout: 8000,
      windowsHide: true,
    });
  } catch {
    // Notification failed silently — non-critical
  }
}

// Read notification from stdin (Claude Code passes event data as JSON)
let input = '';
process.stdin.on('data', (chunk) => { input += chunk; });
process.stdin.on('end', () => {
  try {
    const event = JSON.parse(input || '{}');
    const message = event.message || event.notification || 'Claude Code notification';

    const activeIssue = getActiveIssue();
    const body = activeIssue ? `${message}\n\nActive: ${activeIssue}` : message;

    sendWindowsNotification('Claude Code', body);
  } catch {
    // Non-critical — never fail the hook
  }
  process.exit(0);
});

// Fallback if no stdin data
setTimeout(() => {
  sendWindowsNotification('Claude Code', 'Session activity');
  process.exit(0);
}, 1000);
