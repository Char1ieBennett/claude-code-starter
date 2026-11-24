# Directives (Layer 1)

Plain-English SOPs: one file per repeatable job. Copy `_template.md` to start one,
or let `/systemize` write it after you've done the job a couple of times.

Claude reads the matching directive before doing a job, and updates it whenever it
learns something (an API limit, an edge case, a faster way).
