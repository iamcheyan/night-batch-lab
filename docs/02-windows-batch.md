# 02 — Windows Batch

Start with `windows-batch/nightly-main.bat`. It demonstrates the older style
still found in many operations environments:

- `%~dp0` to locate the script itself
- `setlocal` to contain variables
- `call` to invoke a subroutine or child batch file
- `if errorlevel 1` to stop after a failed step
- labels such as `:error_input` and `goto`
- `copy`, `mkdir`, and `%DATE%` for file operations and business-day folders

Read the script from top to bottom, then trace each `exit /b` value. In a
real site, an outer scheduler may interpret the return code and start an
operator notification or rerun procedure.

The upload script only copies to `data/remote/`. It is deliberately not an
SFTP client.
