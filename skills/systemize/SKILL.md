---
name: systemize
description: Turn a task that keeps coming up into a reliable, repeatable tool, either a project directive plus execution script (3-layer) or a global skill usable in every project. Use when the user types /systemize or says "make this repeatable", "turn this into a tool", "automate this", "we keep doing this", or when you notice the same multi-step task being done for about the third time (then suggest it; don't just do it).
---

# /systemize: the third time, make it a tool

Freehand work is fine once. Repeated work should become a script that gives the same
result every time, plus plain-English instructions for when and how to run it. This is
how the 3-layer system grows: from real work, not from guessing ahead.

## Step 1: Pin down the job
From the conversation (and ask only for what's missing), write down:
- **Trigger**: when does this job come up? What words would the user say?
- **Inputs**: what's given each time, and what keys or accounts are needed?
- **Steps**: what was actually done, including the fixes and gotchas hit along the way.
- **Output**: what "done" looks like, and where the result goes.
- **Which parts need judgement** (Claude) and **which are mechanical** (script).

If it's mostly judgement with little mechanical work (e.g. "write in my voice"), it
needs instructions only, with no script. Say so.

## Step 2: Choose where it lives (recommend one)

| If the job… | Build | Where |
|---|---|---|
| only makes sense in this project | **Directive + script** | `directives/<job>.md` + `execution/<job>.py` |
| is useful across projects | **Global skill** | `~/.claude/skills/<job>/SKILL.md` (+ scripts in that folder) |

A global skill is the same idea packaged to travel: `SKILL.md` is the directive and the
scripts sit beside it. Claude loads it automatically when a request matches its `description`.

## Step 3: Build the script(s)
Follow `execution/README.md` conventions (or the same rules for a skill's scripts):
- One job per script, `argparse` flags, a docstring header covering what it does, inputs, outputs and cost.
- **Dry run by default** for anything that costs money or contacts a person. `--confirm` does it for real.
- Keys from `.env` only, outputs to `.tmp/`, a short summary printed at the end, and fail loudly.
- Put every gotcha from Step 1 *into the code* (retries, rate limits, edge cases). That's the point.

## Step 4: Test it for real
Run it on the real case you just did by hand and compare the result. Fix until it matches.
If testing would spend paid credits, show the dry run and ask before the paid run.

## Step 5: Write the instructions
- **Directive:** copy `directives/_template.md` and fill every section. Put the hard-won lessons under "Edge cases & learnings", with dates.
- **Skill:** write `SKILL.md` with frontmatter:
  ```yaml
  ---
  name: <job>
  description: <what it does + the exact phrases that should trigger it>
  ---
  ```
  then the same sections as a directive. Reference scripts by their full path
  (`~/.claude/skills/<job>/<script>.py`). The `description` is what decides whether it gets used, so make it specific.

## Step 6: Wrap up
- Commit (project) or tell the user where the skill lives (global).
- Tell them in one line how to trigger it next time.
- If a lesson from building it applies beyond this job, save it to memory.
