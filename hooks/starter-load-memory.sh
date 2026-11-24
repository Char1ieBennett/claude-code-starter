#!/usr/bin/env bash
# SessionStart hook: print the global + project memory indexes so Claude starts every
# session knowing what it has already learned. Output becomes session context.
# Capped so a huge index can't flood the context window.
MAX_LINES=150

GLOBAL="$HOME/.claude/memory/MEMORY.md"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
PROJECT="$PROJECT_DIR/MEMORY.md"

print_index() {
  label="$1"; file="$2"
  echo "## $label memory index ($file)"
  head -n "$MAX_LINES" "$file"
  lines=$(wc -l < "$file")
  if [ "$lines" -gt "$MAX_LINES" ]; then
    echo "... ($((lines - MAX_LINES)) more lines; read the file for the rest, and consider tidying it)"
  fi
  echo
}

[ -f "$GLOBAL" ] && print_index "Global" "$GLOBAL"
# Avoid printing the same file twice when Claude is opened inside ~/.claude/memory itself.
if [ -f "$PROJECT" ] && [ "$PROJECT" != "$GLOBAL" ]; then
  print_index "Project" "$PROJECT"
fi
exit 0
