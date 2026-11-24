# Working with Claude Code: the one-page guide

## The 10 habits that matter

1. **One project, one folder, one session.** Open Claude Code *inside* the project folder so it loads that project's `CLAUDE.md` and memory. When you switch to a different task, start a fresh session (`/clear`). Long mixed-up sessions get worse results.

2. **Plan first for anything non-trivial.** Press `Shift+Tab` until you see *plan mode*, describe what you want, and read the plan before letting it build. A two-minute plan review saves an hour of untangling.

3. **Say what "done" looks like.** "Build a script that pulls yesterday's Stripe payments into a Google Sheet, one row per payment" beats "help with Stripe". Give it the goal, where things are, and how it should check its own work.

4. **Let it correct course, then lock it in.** When it gets something wrong, say why ("no, always X because Y"). The memory hook saves that lesson so you only correct it once. You can also just say "remember that…".

5. **Git is your undo button.** Every project is a git repo, and Claude commits when a piece of work is done. If something goes badly wrong, "go back to the last commit" fixes it. That safety net is what lets you be bold.

6. **The third time, make it a tool.** Doing the same thing again? Type `/systemize`. It becomes a script plus instructions (or a skill), and next time it runs the same way in seconds.

7. **Keep secrets in `.env`, keep the master copy in a password manager.** Never paste keys into chat. Claude is blocked from reading `.env`; your scripts load it themselves.

8. **Use `!` for your own commands.** Type `! some command` in the Claude prompt to run it yourself. Use it for logins like `! gh auth login` or anything that needs your password.

9. **Pick a permission mode on purpose.** `Shift+Tab` cycles through modes. Start with the default (it asks before edits and commands). Once you trust a project, accept-edits mode is faster. The ground rules in your `CLAUDE.md` (ask before spending, sending, deleting or publishing) apply in every mode.

10. **Read the memory now and then.** `~/.claude/memory/` and each project's `memory/` are plain text files. Skim them once a month and delete anything wrong or out of date. Bad memories cause bad behaviour.

## Handy commands

| Command | What it does |
|---|---|
| `/clear` | Fresh session. Memory and `CLAUDE.md` reload automatically |
| `/new-project` | Start a new project with the full structure |
| `/systemize` | Turn a repeated task into a reliable tool |
| `/research-wiki` | Start or update a research wiki for a project |
| `/mcp` | Connect apps (Gmail, Calendar, Notion, Stripe…) |
| `/config` | Settings: model, theme and so on |
| `Esc` | Stop Claude mid-action |
| `Esc Esc` | Rewind to an earlier point in the conversation |

## Connecting your apps (MCP)
Connect tools *when a project needs them*, not all at once. Each connector gives Claude new abilities and adds to what it has to think about. Common first ones are your email, calendar and docs. In Claude Code run `/mcp`; on claude.ai, use Settings → Connectors (these carry over to Claude Code).

## When things go wrong
- **It's going in circles:** press `Esc`, say what's wrong in one sentence, or `/clear` and restate the task with more detail.
- **It did something you didn't want:** "undo that", or "reset to the last commit".
- **A script keeps failing:** ask it to read the full error, fix the script, test it, and add the lesson to the directive. That's the self-improving loop working as intended.

## Later, once the basics feel natural
- **Subagents**: Claude can hand big searches or parallel jobs to helper agents so the main conversation stays focused.
- **Hooks**: automatic actions on events (this starter uses two, for memory).
- **Scheduled runs**: run a skill every morning without you there (`/schedule`).
