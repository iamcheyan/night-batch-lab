# night-batch-lab

A small training system for maintaining Japanese financial-device night
batches. The same nightly workflow is shown in three layers:

```text
Windows Batch / Linux Shell
          │ job control, file checks, return-code handling
          ▼
       COBOL
          │ record processing and report creation
          ▼
input → work → output → archive / upload
```

The examples are intentionally old-fashioned. They use fixed paths relative
to the project, Japanese log messages, `ERRORLEVEL`, `CALL`, `GOTO`, `FOR`,
shell exit codes, sequential files, and COBOL `COPY`/`UNSTRING`-style batch
processing. They are for learning and simulation, not for connecting to a
real financial device or production transfer server.

## What the nightly job does

1. Confirm that the input transaction file exists and is not empty.
2. Run the COBOL settlement processor.
3. Check the generated report.
4. Archive the input and output using the business date.
5. Simulate an SFTP upload by copying the report into `data/remote/`.
6. Write a Japanese log and return a non-zero code when a step fails.

The Windows and Linux entry points implement the same workflow independently.
The COBOL program is shared by both examples.

## Quick start on Linux

Requirements: Bash, GNU make, and GnuCOBOL (`cobc`).

```bash
make check
make run
```

After a successful run, inspect:

```text
data/output/settlement-report.txt
data/archive/<business-date>/
data/remote/settlement-report.txt
logs/nightly-<business-date>.log
```

To simulate a failed input check:

```bash
make fail-input
make run
make reset
```

## Windows Batch example

On Windows Command Prompt:

```bat
windows-batch\nightly-main.bat
```

The scripts use `%~dp0` so they can be started from any current directory.
The upload step is local simulation; replace it with the site-approved SFTP
client command only in a controlled environment.

## Lessons

Read these in order:

1. [Job overview](docs/01-job-overview.md)
2. [Windows Batch](docs/02-windows-batch.md)
3. [Linux Shell](docs/03-linux-shell.md)
4. [COBOL processing](docs/04-cobol-processing.md)
5. [Files, logs, and return codes](docs/05-files-logs-and-codes.md)
6. [Failure recovery and rerun](docs/06-failure-recovery.md)

The companion `cobol.nvim` plugin can be used while editing
`src/cobol/NIGHTSETTLE.COB`: fixed-format guides, folding, Copybook navigation,
PIC calculations, completion, diagnostics, and the COBOL context statusline
are all useful in this project.

## Safety

This repository contains fake account numbers and local upload simulation. It
does not implement encryption, production authentication, real SFTP, device
control, or settlement authorization. Never put real customer data or real
credentials in this project.
