# Claude Code Starter

A starting setup for using Claude Code to run a business and many projects, not only to write code.

It gives you four things:

1. **A brain that stays switched on.** A personal `CLAUDE.md` tells Claude who you are, how you like to work, and what it must never do without asking.
2. **Memory that builds up over time.** Claude writes down lessons as you work (corrections, preferences, things that worked) and reads them back at the start of every session. You stop repeating yourself.
3. **A structure that stays reliable.** Projects use a 3-layer setup: *directives* (plain-English instructions), *orchestration* (Claude decides what to do) and *execution* (small scripts that do the same thing every time). Claude does the thinking and the scripts do the repeatable work.
4. **Skills that set it all up for you.** You don't build any of this by hand.

---

## Install (about 5 minutes)

You need a Mac or Linux machine with [Claude Code](https://claude.com/claude-code) installed.

```bash
git clone https://github.com/<owner>/claude-code-starter.git ~/code/claude-code-starter
cd ~/code/claude-code-starter
sh install.sh
```

Then open Claude Code in any folder and type:

```
/setup
```

`/setup` checks your machine, asks you a few questions about yourself and your work, and writes your personal `CLAUDE.md`. After that, start your first project:

```
/new-project
```

The installer never overwrites your files without making a copy first. Backups go to `~/.claude/starter-backups/`.

---

## What you get

| Skill | Type it when | What it does |
|---|---|---|
| `/setup` | Once, on day one | Checks your tools, interviews you, writes your personal `~/.claude/CLAUDE.md` and starts your memory |
| `/new-project` | You start anything new | Creates a project folder with the 3-layer structure, memory, git, secret protection, and a private GitHub repo if you want one |
| `/systemize` | You've done the same task about 3 times | Turns it into a script plus instructions (or a skill), so next time it runs the same way |
| `/research-wiki` | A project needs research that builds up over time | Sets up Karpathy's "LLM Wiki": drop in sources and Claude keeps a linked, cited wiki of what you know |

Claude also uses the last three by itself when the situation fits.

## How it works

```
~/.claude/                     ← yours, applies to every project
├── CLAUDE.md                  who you are + ground rules
├── memory/                    lessons true across ALL projects
│   └── MEMORY.md              the index Claude reads every session
├── skills/                    setup, new-project, systemize, research-wiki
└── hooks/                     load memory at start, check for lessons every message

~/code/<project>/              ← one per project, each its own git repo
├── CLAUDE.md                  what this project is + how to work in it
├── MEMORY.md + memory/        lessons true for THIS project only
├── directives/                Layer 1: SOPs in plain English
├── execution/                 Layer 3: scripts that do the actual work
├── .tmp/                      scratch files (never committed)
└── .env                       API keys (never committed, never read by Claude)
```

Claude is Layer 2, in the middle. It reads a directive, runs the right scripts in order, handles errors, and updates the directive with what it learned.

**Why bother?** If Claude does every step freehand, mistakes stack up: 90% accuracy per step over 5 steps is 59%. Scripts run the same way every time, so Claude only has to make the decisions.

**Memory** has two levels. Global (`~/.claude/memory/`) holds things like "keep answers short" or "this API limits us to 100 calls a minute". Project (`<project>/memory/`) holds facts about that one project. A small hook loads both at the start of every session. Another one asks Claude after every message: "did I learn something worth keeping?"

## Read next

- [skills/setup/GUIDE.md](skills/setup/GUIDE.md): how to get good results from Claude Code, in one page.

## Updating

```bash
cd ~/code/claude-code-starter && git pull && sh install.sh
```

This refreshes the skills and hooks. Your `CLAUDE.md` and memory are never touched.

## Uninstall

Delete `~/.claude/skills/{setup,new-project,systemize,research-wiki}` and `~/.claude/hooks/starter-*.sh`, then remove the two `starter-` hook entries from `~/.claude/settings.json`. Your memory and `CLAUDE.md` stay unless you delete them.

## Credits

- The memory loop is adapted from Andrej Karpathy's [autoresearch](https://github.com/karpathy/autoresearch) idea: keep what makes the next run better, throw away the rest.
- `/research-wiki` follows Karpathy's [LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) pattern.

MIT licence.
