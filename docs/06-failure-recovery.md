# 06 — Failure recovery and rerun

A night operator must be able to answer whether a job can be rerun safely.
This lab keeps the example simple and local:

```bash
make fail-input
make run
echo $?
make reset
make run
```

The first run stops during input validation. `make reset` restores the fake
input file and clears generated output, remote, and log files before the next
run.

Study the difference between:

- a missing input: do not run COBOL;
- a malformed record: reject the batch before settlement;
- a missing output: do not archive or upload;
- an upload failure: the local report remains available for controlled retry.

In a production design, archive naming, duplicate-run protection, lock files,
operator approval, and transfer acknowledgements would need to be specified
explicitly.
