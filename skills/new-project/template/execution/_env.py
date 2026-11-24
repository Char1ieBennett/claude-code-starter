"""Tiny .env loader (no dependencies). Import and call load_env() at the top of a script.

Reads KEY=value lines from the project's .env into os.environ, without overriding
variables that are already set. Use require("KEY") to fail clearly if a key is missing.
"""
import os
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent


def load_env(path: Path = PROJECT_ROOT / ".env") -> None:
    if not path.exists():
        return
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        value = value.strip().strip('"').strip("'")
        os.environ.setdefault(key.strip(), value)


def require(key: str) -> str:
    value = os.environ.get(key)
    if not value:
        raise SystemExit(f"Missing {key}. Add a line '{key}=...' to .env (see .env.example).")
    return value
