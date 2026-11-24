# {{PROJECT_NAME}}

> Project instructions for Claude. They add to the personal `~/.claude/CLAUDE.md`.
> Started {{DATE}}.

## What this is
{{PURPOSE}}

## Context
<!-- Goals, people involved, deadlines, constraints. Claude adds to this as it learns. -->

## Start of every session
1. The memory hook loads `MEMORY.md` (this project) and the global index automatically. Open the full memory files for anything that touches the task.
2. If the task matches a directive in `directives/`, read it before doing anything.
3. Check `execution/` for an existing script before writing a new one.

## The 3 layers

**Layer 1: Directives (what to do)**: `directives/*.md`
SOPs in plain English: goal, inputs, which scripts to run, outputs, edge cases. Write them the way you'd brief a capable new hire.

**Layer 2: Orchestration (deciding)**: Claude
Read the directive, call scripts in the right order, handle errors, ask when it's genuinely the user's call, and update the directive with what you learn.

**Layer 3: Execution (doing)**: `execution/*.py`
Small scripts that give the same result every time: API calls, data processing, files. Keys come from `.env`. See `execution/README.md` for conventions.

**Why:** 90% accuracy per step is only 59% over 5 steps. Pushing repeatable work into scripts keeps the whole chain reliable, so Claude only has to make the decisions.

## The self-improving loop
When something breaks:
1. Read the error and fix the script.
2. Test it. If testing would spend paid credits, ask first.
3. Add the lesson to the directive (API limits, timing, edge cases).
4. If the lesson applies beyond this project, also save it to global memory.

Directives are living documents. Improve them, but don't create new ones or rewrite one wholesale without asking.

## Memory
- `MEMORY.md` (index) + `memory/*.md`: lessons true for **this project only**.
- Lessons true everywhere go in `~/.claude/memory/` instead.
- Format and capture rules: see the Memory section of `~/.claude/CLAUDE.md`.

## Files
- `directives/`: SOPs (Layer 1)
- `execution/`: scripts (Layer 3)
- `.tmp/`: scratch and intermediate files. Never committed, safe to delete.
- `.env`: secrets. Never committed, never read by Claude. `.env.example` lists the key names.
- Finished work (reports, sheets, docs) goes where the user will use it, not buried in `.tmp/`.

## Git
Claude does the git work: commit with a plain message when a piece of work is done, then push.
The pre-commit hook blocks secrets. If it fires, fix the cause; never bypass it with `--no-verify`.
