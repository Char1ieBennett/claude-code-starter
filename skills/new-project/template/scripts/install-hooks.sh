#!/usr/bin/env sh
# Run once after cloning this project on a new machine: installs the secret-blocking git hook.
cd "$(dirname "$0")/.." || exit 1
cp scripts/pre-commit.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
echo "Installed pre-commit hook."
