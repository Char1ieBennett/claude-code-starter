#!/usr/bin/env python3
"""Example execution script: copy this pattern for new scripts, then delete this file.

What it does: counts the words in a text file and writes a JSON summary to .tmp/.
Inputs:  --file path/to/file.txt
Outputs: .tmp/word_count.json, plus a one-line summary on stdout
Cost:    free. (Paid scripts must default to a dry run and need --confirm.)
"""
import argparse
import json
from pathlib import Path

from _env import PROJECT_ROOT, load_env


def main() -> None:
    parser = argparse.ArgumentParser(description="Count words in a text file.")
    parser.add_argument("--file", required=True, help="Text file to count")
    parser.add_argument("--confirm", action="store_true",
                        help="Actually write the output (default is a dry run)")
    args = parser.parse_args()

    load_env()  # keys are then available via os.environ / _env.require("KEY")

    path = Path(args.file)
    if not path.exists():
        raise SystemExit(f"File not found: {path}")
    words = len(path.read_text().split())

    if not args.confirm:
        print(f"DRY RUN: {path} has {words} words. Re-run with --confirm to save.")
        return

    out = PROJECT_ROOT / ".tmp" / "word_count.json"
    out.parent.mkdir(exist_ok=True)
    out.write_text(json.dumps({"file": str(path), "words": words}, indent=2))
    print(f"OK: {words} words -> {out}")


if __name__ == "__main__":
    main()
