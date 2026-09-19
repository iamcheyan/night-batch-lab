# AGENTS.md — night-batch-lab

## Project purpose

This repository has two connected purposes:

1. It is a hands-on learning project for the three technologies used in
   Japanese financial-device night operations:

   - Windows Batch (`.bat`)
   - Linux Shell (`.sh`)
   - fixed-format COBOL (`.COB`, Copybooks)

2. It is a realistic dogfooding project for `cobol.nvim`. While studying or
   maintaining these examples, record anything that feels awkward in Neovim
   and turn it into a small, reusable plugin improvement. The practice project
   should expose plugin problems; it should not hide them with one-off local
   mappings or machine-specific configuration.

## Learning loop

For each lesson:

1. Read the lesson document.
2. Run the Linux version with `make run`.
3. Inspect the input, output, archive, remote simulation, and log files.
4. Open the COBOL source in Neovim and use the relevant `cobol.nvim` feature.
5. Reproduce at least one failure and perform a safe rerun.
6. If editing is awkward, write a short issue note under `docs/plugin-notes/`:

   ```text
   Problem: what was difficult
   Context: file and line or workflow
   Expected: the desired editor behavior
   Candidate: a general plugin feature, if known
   ```

7. Only then implement a plugin change in the separate `cobol.nvim` repo.

## Repository boundaries

- `windows-batch/` contains Windows-specific orchestration examples.
- `windows-batch/csv2xls-upload.bat` intentionally processes ten numbered CSV
  files with ten explicit calls. Keep this repetition: it models the coded
  job steps used in the target work environment.
- `scripts/linux/` contains Linux-specific orchestration examples.
- `tests/` contains lightweight static contract checks for the long-form
  Windows Batch examples; it does not require Windows or an FTP server.
- `src/cobol/` contains COBOL programs and Copybooks.
- `data/` contains fake training data only. Never add customer data,
  credentials, production hostnames, or real account information.
- `docs/` contains the lessons and operational explanations.
- `cobol.nvim` remains a separate repository. Do not copy plugin source into
  this project.

## Safety rules

- The normal nightly job uses local upload simulation into `data/remote/`.
- The ten-file exercise may contain the documented FTP command contract, but
  never add real FTP credentials, production hosts, or customer data.
- Every script must use explicit return codes and stop on failed required
  steps.
- External converters and FTP connection values must be injected through an
  environment variable or a documented command contract; do not commit them
  when they belong to a real site.
- Archive operations must be reversible during practice.
- Keep Japanese log messages, because reading operational Japanese is part of
  the exercise.
- Prefer a dry-run or simulation before any destructive command.

## Validation

From the repository root:

```bash
make check
make reset
make run
```

Before committing, also check shell syntax and the COBOL compiler result:

```bash
bash -n scripts/linux/*.sh
cobc -fsyntax-only -I src/cobol/copybooks src/cobol/NIGHTSETTLE.COB
git diff --check
git status
```

Changes to `cobol.nvim` must be made and tested in its own repository, then
linked back to the relevant lesson or plugin note here.
