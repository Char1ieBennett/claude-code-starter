# Execution scripts (Layer 3)

Small, reliable scripts. Claude decides *when* to run them; the scripts do the work the
same way every time.

## Conventions
- **One script, one job.** Name it for what it does: `fetch_stripe_payments.py`, not `utils.py`.
- **Arguments via `argparse`**, with a `--help` that explains every flag.
- **Anything that spends money or contacts a person** (paid APIs, sending email, posting)
  does a dry run by default and needs `--confirm` to do it for real.
- **Secrets from `.env`** via `load_env()` in `_env.py`. Never hard-code keys and never print them.
- **Outputs:** intermediate files go to `.tmp/`. Print a short summary when finished
  (counts, where the output went), so Claude can check the result.
- **Fail loudly.** Exit non-zero with a clear message. Never swallow errors.
- A comment at the top says what the script does, its inputs and outputs, and its cost if it has one.

See `example_script.py` for the pattern.
