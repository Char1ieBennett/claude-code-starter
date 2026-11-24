#!/usr/bin/env sh
# Git pre-commit hook: refuse to commit secrets.
# Installed into .git/hooks/pre-commit by /new-project (or scripts/install-hooks.sh).
fail=0

# 1. Secret or scratch files by name
bad=$(git diff --cached --name-only --diff-filter=ACM | grep -E \
  '(^|/)(\.env|\.env\.local|credentials[^/]*\.json|token(\.[^/]*)?\.json|service-account[^/]*\.json)$|\.(pem|key)$|^\.tmp/')
if [ -n "$bad" ]; then
  echo "BLOCKED: these look like secret or scratch files:"
  echo "$bad" | sed 's/^/  /'
  echo "Unstage them with: git restore --staged <file>"
  fail=1
fi

# 2. Things that look like real API keys in the added lines
if git diff --cached -U0 --diff-filter=ACM | grep -E '^\+' | grep -v '^+++' | \
   grep -Eq '(sk-[A-Za-z0-9_-]{20,}|sk_live_[A-Za-z0-9]{16,}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----)'; then
  echo "BLOCKED: a staged change contains something that looks like an API key or private key."
  echo "Move it to .env and load it from there."
  fail=1
fi

exit $fail
