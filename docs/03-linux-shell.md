# 03 — Linux Shell

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
