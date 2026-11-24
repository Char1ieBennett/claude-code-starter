#!/usr/bin/env sh
# Claude Code Starter installer.
# Copies the skills and hooks into ~/.claude, registers the hooks in settings.json,
# and seeds your personal CLAUDE.md + memory if you don't have them yet.
# Anything it would replace is backed up to ~/.claude/starter-backups/<timestamp>/ first.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$CLAUDE_DIR/starter-backups/$STAMP"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is missing. On a Mac run:  xcode-select --install   then re-run this."
  exit 1
fi

echo "Installing Claude Code Starter into $CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/hooks" "$CLAUDE_DIR/memory"

backup() {  # backup <path> : move/copy an existing file or folder into the backup dir
  mkdir -p "$BACKUP"
  cp -R "$1" "$BACKUP/"
}

# 1. Skills (refreshed on every install; old copies backed up)
for src in "$HERE"/skills/*/; do
  name="$(basename "$src")"
  dest="$CLAUDE_DIR/skills/$name"
  if [ -e "$dest" ]; then backup "$dest"; rm -rf "$dest"; fi
  cp -R "$src" "$dest"
  echo "  skill: /$name"
done

# 2. Hooks
for src in "$HERE"/hooks/*.sh; do
  cp "$src" "$CLAUDE_DIR/hooks/"
  chmod +x "$CLAUDE_DIR/hooks/$(basename "$src")"
done
echo "  hooks: memory loader + memory reminder"

# 3. Personal CLAUDE.md: never overwrite yours
if [ -f "$CLAUDE_DIR/CLAUDE.md" ] && grep -q "claude-code-starter" "$CLAUDE_DIR/CLAUDE.md"; then
  echo "  CLAUDE.md: kept your personalised one"
elif [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$HERE/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.starter.md"
  echo "  CLAUDE.md: you already have one, so it was left alone."
  echo "             The starter version is at ~/.claude/CLAUDE.starter.md; /setup will merge them."
else
  cp "$HERE/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  echo "  CLAUDE.md: created (run /setup to personalise it)"
fi

# 4. Global memory index: never overwrite
if [ ! -f "$CLAUDE_DIR/memory/MEMORY.md" ]; then
  cp "$HERE/global/memory/MEMORY.md" "$CLAUDE_DIR/memory/MEMORY.md"
  echo "  memory: created ~/.claude/memory/MEMORY.md"
else
  echo "  memory: kept your existing ~/.claude/memory/"
fi

# 5. Register hooks + secret protection in settings.json
python3 "$HERE/scripts/merge_settings.py" "$CLAUDE_DIR/settings.json" "$BACKUP"

[ -d "$BACKUP" ] && echo "  backups: $BACKUP"

cat <<'MSG'

Done. Next:
  1. Open Claude Code (quit and reopen it if it was already running, so the hooks load).
  2. Type:  /setup
MSG
