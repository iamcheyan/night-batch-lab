#!/usr/bin/env bash
set -euo pipefail

script="${1:-windows-batch/csv2xls-upload.bat}"

assert_contains() {
  local pattern="$1"
  if ! grep -Fq -- "$pattern" "$script"; then
    printf 'missing contract: %s\n' "$pattern" >&2
    exit 1
  fi
}

assert_contains 'setlocal EnableExtensions EnableDelayedExpansion'
assert_contains 'call :preflight_inputs'
assert_contains 'for %%J in (000000001 000000002 000000003 000000004 000000005 000000006 000000007 000000008 000000009 000000010) do ('
assert_contains 'call :process_job 000000001'
assert_contains 'call :process_job 000000010'
assert_contains 'call :write_log'
assert_contains 'call :write_status'
assert_contains 'call :archive_job'
assert_contains 'if /I "%UPLOAD_MODE%"=="ftp" goto :upload_ftp'
assert_contains 'ftp -n -s:"%FTP_COMMAND_FILE%"'
assert_contains 'if /I "%OVERWRITE_OUTPUT%"=="N" if exist "%XLS_FILE%" ('
assert_contains 'if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error'
assert_contains 'call "%~dp0load-config.bat" "%CONFIG_FILE%"'
assert_contains 'set "CSV_DIR=%CSV2XLS_CSV_DIR%"'
assert_contains 'set "CSV2XLS_JS=%CSV2XLS_CONVERTER%"'

explicit_calls="$(grep -Ec '^call :process_job 00000000[1-9]$|^call :process_job 000000010$' "$script")"
if [[ "$explicit_calls" -ne 10 ]]; then
  printf 'expected 10 explicit process calls, found %s\n' "$explicit_calls" >&2
  exit 1
fi

printf 'batch contract: OK\n'
