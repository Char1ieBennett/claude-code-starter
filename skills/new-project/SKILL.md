---
name: new-project
description: Create a new project folder with the 3-layer structure (directives / orchestration / execution), project memory, git, secret protection and an optional private GitHub repo. Use when the user types /new-project or says "start a new project", "set up a folder for X", "new repo for", "I want to start working on <idea>".
---

# /new-project: scaffold a project on good foundations

The template lives next to this file in `template/`. You copy it, fill it in, and wire up git.
Do the work yourself. The user should only answer questions about the project.

## Step 1: Ask (one message, skip anything they've already told you)
- **Name**: becomes the folder name as a kebab-case slug, e.g. `pricing-research`.
- **What it's for**: one or two sentences. What does success look like?
- **GitHub**: create a private GitHub repo and push? Recommend yes. It's an off-machine backup.

Projects live in the projects root set in `~/.claude/CLAUDE.md` (default `~/code`).
If `<root>/<slug>` already exists, stop and ask. Never overwrite.

## Step 2: Copy the template
```bash
ROOT=~/code            # or the root from ~/.claude/CLAUDE.md
SLUG=<slug>
T=~/.claude/skills/new-project/template
mkdir -p "$ROOT/$SLUG" && cp -R "$T"/. "$ROOT/$SLUG"/
cd "$ROOT/$SLUG"
mv gitignore .gitignore && mv env.example .env.example && cp .env.example .env
mkdir -p .tmp
```
(The template stores `gitignore` / `env.example` without the leading dot so they don't affect the starter repo itself.)

## Step 3: Fill it in
- In `CLAUDE.md`, replace `{{PROJECT_NAME}}`, `{{PURPOSE}}` and `{{DATE}}` (today, as YYYY-MM-DD).
- If the user gave goals, constraints, people involved or deadlines, add them under "Context".
- Check no `{{` placeholders are left: `grep -rn "{{" . --include='*.md'`.

## Step 4: Git
```bash
git init -q -b main
cp scripts/pre-commit.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
git add -A && git commit -qm "Start project: <name>"
```
The pre-commit hook refuses to commit `.env`, credential files and anything that looks like an API key.
`scripts/install-hooks.sh` reinstalls it after a fresh clone on another machine.

If they want GitHub (needs `gh auth status` to be OK; if not, have them run `! gh auth login`):
```bash
gh repo create <slug> --private --source . --push
```
Always `--private` unless they explicitly say public.

## Step 5: Python environment (only if the project will have scripts)
Most projects will. Set it up now so scripts just work:
```bash
python3 -m venv .venv && .venv/bin/pip install -q -r requirements.txt
```
Scripts are run as `.venv/bin/python execution/<script>.py`.

## Step 6: Hand over
Tell them in a few lines:
- Where the project is, and the GitHub link if one was made.
- **To work on it, open Claude Code in that folder** (`cd <path> && claude`, or File → Open Folder in an editor). That way the project's CLAUDE.md and memory load.
- If it needs API keys, list which lines to add to `.env`. They add the values themselves.
- If the project involves research or collecting lots of sources, mention `/research-wiki`.
