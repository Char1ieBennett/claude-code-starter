---
name: research-wiki
description: Build and maintain an LLM-written research wiki inside a project, following Karpathy's "LLM Wiki" pattern. Raw sources go in, and Claude keeps a linked, cited markdown wiki of what's known. Use when the user types /research-wiki or wants to research a market, competitor, industry, deal, person or topic over time; says "add this to the wiki", "ingest this", "what do we know about X", "check the wiki"; or drops articles, transcripts, PDFs or notes to be kept and built on.
---

# /research-wiki: knowledge that compounds

Based on Andrej Karpathy's LLM Wiki pattern
(https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).
Instead of re-reading raw documents every time a question comes up, Claude keeps a
wiki *between* you and your sources. Each new source updates the pages it affects, so
knowledge builds up. Humans give up on wikis because the bookkeeping grows faster than
the value. Claude does the bookkeeping.

**Note the difference from memory:** memory holds lessons about *how to work*. The wiki holds
*knowledge about a subject*. Projects can have both.

## Layout (inside the current project)
```
wiki/
├── WIKI.md        the schema: what this wiki covers, page types, conventions (we evolve it together)
├── index.md       catalogue: one line per page, grouped by category. Read this first, always.
├── log.md         append-only history:  ## [YYYY-MM-DD] ingest | <source title>
├── raw/           original sources: articles, transcripts, PDFs, notes. NEVER edited.
└── pages/         Claude-written pages: summaries, entities, concepts, comparisons, overview
```

## Operations

### init (first use)
1. Ask what the wiki is for in one sentence, and what kinds of things it will track (e.g. companies, people, pricing, regulations).
2. Create the layout. Write `WIKI.md` with: purpose, page types and a naming convention (`pages/<type>-<slug>.md`), the citation rule, and anything the user cares about. Start `index.md` and `log.md`.
3. Add one line to the project's `CLAUDE.md`: "Research lives in `wiki/`. Follow `wiki/WIKI.md`; read `wiki/index.md` before answering questions about <topic>."

### ingest (one source at a time by default)
1. Save the source unchanged to `raw/` (`raw/YYYY-MM-DD-<slug>.md`; for web pages, save the text plus its URL at the top).
2. Read it, then tell the user the 3–5 key takeaways and anything that **contradicts** what the wiki already says. Let them react. This is where their judgement goes in.
3. Write a summary page for the source, then update every entity and concept page it touches (often 5–15 pages). Create pages that should exist.
4. **Every claim cites its source**: `([source](../raw/2026-03-14-acme-pricing.md))`. No citation, no claim.
5. Update `index.md`, and append to `log.md`.
6. Batch ingest is fine when the user asks. Do the summaries first, then one pass of cross-page updates.

### query
1. Read `index.md`, open the relevant pages, and answer with citations.
2. **For exact facts** (numbers, dates, quotes, prices), check the raw source the page cites, not just the summary. Summaries lose detail, and that's the pattern's known weak spot.
3. If the answer was worth working out, offer to save it as a new page (e.g. a comparison or synthesis).

### lint (when asked, or every ~10 ingests: suggest it)
Look for contradictions between pages, stale claims superseded by newer sources, orphan
pages, things mentioned on several pages that deserve their own page, missing
cross-links, and claims without citations. Report first, then fix with the user's OK.
Point out gaps that a web search could fill.

## Rules
- `raw/` is read-only once saved.
- Prefer updating an existing page over creating a near-duplicate.
- Date everything time-sensitive ("as of 2026-03"). Markets and prices go stale.
- Scale: the index-first approach works up to roughly 100 sources or a few hundred pages. Past that, suggest adding a search tool.
- Commit after each ingest session, so the wiki's history is in git.
- Works well with Obsidian (open `wiki/` as a vault) if the user wants a visual graph. It's optional.
