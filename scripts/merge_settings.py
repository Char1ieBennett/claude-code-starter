#!/usr/bin/env python3
"""Add the starter's hooks and secret-protection rules to ~/.claude/settings.json.

Safe to run repeatedly: it only adds entries that aren't there yet, keeps everything
else in the file, and backs up the original first.

Usage: python3 merge_settings.py <settings.json path> <backup dir>
"""
import json
import shutil
import sys
from pathlib import Path

HOOKS = {
    "SessionStart": "bash ~/.claude/hooks/starter-load-memory.sh",
    "UserPromptSubmit": "bash ~/.claude/hooks/starter-memory-reminder.sh",
}
# Stop Claude reading secret files with its Read tool. Scripts still load .env themselves.
DENY = ["Read(**/.env)", "Read(**/.env.local)"]


def main() -> None:
    settings_path = Path(sys.argv[1]).expanduser()
    backup_dir = Path(sys.argv[2]).expanduser()

    settings = {}
    if settings_path.exists():
        text = settings_path.read_text().strip()
        if text:
            try:
                settings = json.loads(text)
            except json.JSONDecodeError as e:
                sys.exit(f"Could not parse {settings_path} ({e}). Fix or move it, then re-run.")
        backup_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(settings_path, backup_dir / "settings.json")

    changed = []
    hooks = settings.setdefault("hooks", {})
    for event, command in HOOKS.items():
        groups = hooks.setdefault(event, [])
        already = any(
            h.get("command") == command
            for g in groups for h in g.get("hooks", [])
        )
        if not already:
            groups.append({"hooks": [{"type": "command", "command": command}]})
            changed.append(f"hook {event}")

    deny = settings.setdefault("permissions", {}).setdefault("deny", [])
    for rule in DENY:
        if rule not in deny:
            deny.append(rule)
            changed.append(f"deny {rule}")

    settings_path.parent.mkdir(parents=True, exist_ok=True)
    settings_path.write_text(json.dumps(settings, indent=2) + "\n")
    print("  settings.json: " + (", ".join(changed) if changed else "already up to date"))


if __name__ == "__main__":
    main()
