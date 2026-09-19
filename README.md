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
delayed variable expansion, lock directories, staged files, status files,
shell exit codes, sequential files, and COBOL `COPY`/`UNSTRING`-style batch
processing. They are for learning and simulation, not for connecting to a
real financial device or production transfer server.

## What the nightly job does

1. Confirm that the input transaction file exists and is not empty.
2. Run the COBOL settlement processor.
3. Check the generated report.
4. Archive the input and output using the business date.
5. Simulate an FTP upload by copying the report into `data/remote/`.
6. Write a Japanese log and return a non-zero code when a step fails.

There is also a deliberately explicit Windows job for a common legacy
workflow: `windows-batch/csv2xls-upload.bat` processes exactly ten numbered
CSV files (`000000001` through `000000010`), calls an external `CSV2XLS.js`
converter for each one, and uploads each generated XLS file to a Linux host.
The ten calls are written one by one on purpose; this mirrors operations code
where each job step has its own return-code checkpoint. A preflight loop is
used only to inspect all inputs before the coded job steps begin.

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
The upload step is local simulation by default. In a controlled environment,
the ten-file job can use the site-approved Windows `ftp.exe` client.

The longer Batch example also demonstrates business-day arguments, directory
creation, input-size checks, configurable overwrite behavior, optional
continue-on-error behavior, per-job status records, logs, output archiving,
and explicit failure codes. These are intentionally included as editor and
plugin test cases, not as a recommendation to copy production credentials.

For the ten-file conversion exercise, set the converter and upload mode as
appropriate:

```bat
set CSV2XLS_JS=C:\tools\CSV2XLS.js
set UPLOAD_MODE=simulate
windows-batch\csv2xls-upload.bat
```

For an approved FTP endpoint, set the connection values outside the repository:

```bat
set UPLOAD_MODE=ftp
set FTP_HOST=approved-linux-host
set FTP_USER=approved-user
set FTP_PASSWORD=provided-out-of-band
set FTP_TARGET=/var/tmp/approved-directory
windows-batch\csv2xls-upload.bat
```

Each numbered job creates one temporary FTP command file, uploads one XLS
file, checks the FTP return code, and removes the command file. There is no
upload loop.

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
does not implement encryption, production authentication, device control, or
settlement authorization. Never put real customer data or real credentials in
this project.
