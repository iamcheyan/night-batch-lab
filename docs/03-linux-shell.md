# 03 — Linux Shell

The Linux version is intentionally more detailed than a minimal wrapper. It
models the control code that usually surrounds a COBOL executable in a night
operation.

`scripts/linux/nightly-main.sh` demonstrates:

- command-line options and environment-controlled recovery modes;
- a business-date lock directory to prevent duplicate execution;
- `trap` cleanup for staged output and locks;
- dry-run mode, explicit return-code branches, and retry policy;
- writing output to a temporary file before moving it into place;
- archive creation, SHA-256 manifest generation, upload simulation, and
  post-upload `cmp` verification.

`validate-input.sh` demonstrates a record-reading `while` loop, CSV splitting,
regular-expression validation, maximum-record limits, duplicate detection,
status counters, and numeric totals. `upload-sim.sh` demonstrates a temporary
`.part` file, atomic rename, file-size verification, and an injectable failure
switch for recovery practice.

These scripts are deliberately verbose so they provide realistic shell text
for testing `cobol.nvim` navigation, folding, diagnostics, completion, and
context display.

The Linux entry point is `scripts/linux/nightly-main.sh`. It performs the same
workflow as the Batch version, but uses common shell operations:

- `set -u` to catch unset variables
- `BASH_SOURCE` to locate the project root
- functions for logging and failure handling
- `|| fail "step"` for explicit return-code propagation
- `tee` to write both the terminal and a Japanese log
- quoted paths to survive spaces in directory names

Compare it with the Windows version. The business workflow is shared, but the
failure and path conventions are not. This distinction matters when a site
migrates one part of a night operation to Linux.
