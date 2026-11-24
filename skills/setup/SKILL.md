---
name: setup
description: First-time setup for Claude Code Starter. Checks the machine's tools, interviews the user about themselves and their work, writes their personal ~/.claude/CLAUDE.md, and seeds their global memory. Run once on day one, or again to redo the profile. Triggers on "/setup", "set me up", "personalise my Claude".
disable-model-invocation: true
---

# /setup: get this person started on good foundations

You are setting up Claude Code for someone who may be new to it. They're an entrepreneur
working on several projects. Be warm, quick and plain-spoken. Do the work yourself and
only ask them things that only they can answer. The whole thing should take about 10 minutes.

## Step 1: Check the machine (read-only)

Run these checks in one go and report results as a short checklist:

```bash
for t in git gh python3 node brew; do printf "%-8s" "$t"; command -v $t >/dev/null && echo "ok ($($t --version 2>&1 | head -1))" || echo "MISSING"; done
git config --global user.name; git config --global user.email
gh auth status 2>&1 | head -3
ls ~/.claude/hooks/starter-*.sh ~/.claude/memory/MEMORY.md 2>&1
grep -c starter- ~/.claude/settings.json
```

For anything missing, give the exact fix and **ask before installing anything**:
- `brew` (Mac): https://brew.sh. It's one command the user pastes into their own Terminal, because it needs their password.
- `git`, `python3`: `xcode-select --install` on Mac.
- `gh`: `brew install gh`, then the user logs in by typing `! gh auth login` into the Claude prompt. The `!` runs it in their own shell so they can use the browser login.
- `node`: optional. Only needed for JavaScript projects or some MCP servers. Skip unless they want it.
- If the starter hooks or the `starter-` entries in settings.json are missing, tell them to run `sh install.sh` from the starter repo and reopen Claude Code.

## Step 2: Git identity
If `user.name` / `user.email` are empty, ask for them and set them with `git config --global`.
Point out that this email shows on every commit. A GitHub "noreply" address is fine if they want privacy.

## Step 3: Interview (one AskUserQuestion round, plus one short free-text follow-up)

Use AskUserQuestion for the multiple-choice bits:
1. **Answer style**: "Short and direct" (recommended) / "Detailed with reasoning" / "Short by default, detail when I ask".
2. **Technical comfort**: "Non-technical, explain everything" / "Comfortable, can read code" / "Developer".
3. **Spending guardrail**: ask before any paid action over "£0, always ask" / "£5" / "£20" / "£50". Use their currency.
4. **Spelling**: British / American.

Then ask in plain text, all in one message:
- Their name, and what they do in one or two lines.
- The businesses or projects they're working on now.
- Where they're based (for timezone and currency).
- Where they want project folders to live. The default is `~/code`. Recommend it and don't use a cloud-synced folder like Dropbox or iCloud, because sync tools and git fight each other.

## Step 4: Write their personal CLAUDE.md

- If `~/.claude/CLAUDE.starter.md` exists, they already had a CLAUDE.md before installing. Merge: keep everything of theirs, add the starter's sections that are missing, and show them a short summary of what you added. Then delete `CLAUDE.starter.md`.
- Otherwise, fill the `{{PLACEHOLDERS}}` in `~/.claude/CLAUDE.md` with their answers:
  `{{NAME}}`, `{{WHAT_I_DO}}`, `{{PROJECTS}}`, `{{TECH_LEVEL}}`, `{{LOCATION}}`,
  `{{ANSWER_STYLE}}` (write it as an instruction, e.g. "Keep answers short and direct. Lead with the answer."),
  `{{SPELLING}}`, `{{SPEND_LIMIT}}` (e.g. "£20"), `{{PROJECTS_ROOT}}` (e.g. `~/code`).
- If they're non-technical, add this line under "How to talk to me": "I don't type terminal commands. Run them yourself, or give me exactly one thing to paste."
- Check that no `{{` placeholders are left.

## Step 5: Seed global memory
Create `~/.claude/memory/user-profile.md` (type `user`) with the useful facts from the interview that aren't already in CLAUDE.md. Keep it short. Add its line to `~/.claude/memory/MEMORY.md`.
Then explain the memory loop in 3 sentences: you'll save lessons as you go, they can say "remember that…" whenever they like, and they can open `~/.claude/memory/` at any time to read or delete what's there.

## Step 6: Secrets
Explain in 3 or 4 lines:
- API keys go in each project's `.env`. It's never committed to git, and Claude is blocked from reading it.
- Keep the master copy of every key in a password manager (1Password or Bitwarden), so a new laptop takes minutes, not days.
- Don't paste keys into chat.

## Step 7: Finish
1. Create the projects folder if it doesn't exist (`mkdir -p`).
2. Show the one-page guide: read `GUIDE.md` from this skill's folder (`~/.claude/skills/setup/GUIDE.md`) and summarise its 5 most important habits in a short list. Tell them the full guide is there.
3. Recommend next: `/new-project` for whatever they want to work on first.
4. If anything was installed or the hooks were just added, remind them to quit and reopen Claude Code once so everything loads.
