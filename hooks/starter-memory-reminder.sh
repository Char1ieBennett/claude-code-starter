#!/usr/bin/env bash
# UserPromptSubmit hook: a one-line nudge on every message so the memory loop actually runs.
# It only reminds Claude to check; it never writes anything itself.
echo "[memory] After handling this message: is there a durable learning (correction, preference, confirmed approach, hard fact)? If yes, update ~/.claude/memory/ (true everywhere) or this project's memory/ (true here only) and its MEMORY.md index. If not, do nothing."
exit 0
