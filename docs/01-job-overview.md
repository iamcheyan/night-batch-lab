# 01 — Job overview

This lab models a nightly settlement job for a financial device. The job is
not a single program; it is a chain of responsibilities.

```text
start
  └─ check input arrival
       └─ run COBOL processor
            └─ check output
                 └─ archive
                      └─ transfer
                           └─ finish with a return code
```

The most important operational question is not “did the script finish?” but
“which step finished, with which return code, and what can be safely rerun?”

Practice commands:

```bash
make check
make run
find data logs -type f -maxdepth 3 -print
```

In Neovim, open `src/cobol/NIGHTSETTLE.COB` and identify the `0000`, `1000`,
`1100`, and `2000` paragraphs before running the job.
