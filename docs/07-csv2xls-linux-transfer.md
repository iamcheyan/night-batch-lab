# 07 — Ten CSV files, XLS conversion, and Linux transfer

`windows-batch/csv2xls-upload.bat` models a job often found around legacy
devices: ten separately numbered input files arrive, each is converted by a
site-provided JavaScript program, and each result is sent to a Linux server.

The files are:

```text
000000001.csv
000000002.csv
...
000000010.csv
```

The script intentionally contains ten explicit blocks:

```bat
call :convert_and_upload 000000001
if errorlevel 1 goto :error
call :convert_and_upload 000000002
if errorlevel 1 goto :error
```

Do not replace these calls with `FOR`. In this exercise, the repetition is a
lesson: read the job code as an operator, identify which numbered file failed,
and understand how a return code stops the following steps.

## CSV2XLS.js contract

The batch file expects the external converter to accept:

```text
node CSV2XLS.js INPUT.csv OUTPUT.xls
```

The actual converter is intentionally not included. In a real environment it
may be a vendor-provided or site-maintained script. Put it outside Git or set
the `CSV2XLS_JS` environment variable to its path.

## Upload modes

The safe default is local simulation:

```bat
set UPLOAD_MODE=simulate
```

Generated XLS files are copied to `data/remote/linux/`. The production-shaped
branch uses OpenSSH `scp`:

```bat
set UPLOAD_MODE=ssh
set LINUX_HOST=operator@approved-host
set LINUX_TARGET=/var/tmp/approved-directory
```

Never commit real hosts, account names, keys, passwords, or customer data.

## Practice questions

1. What happens if `000000006.csv` is missing?
2. What happens if `CSV2XLS.js` returns `1` for file 000000004?
3. Which files have already been converted when file 000000007 fails?
4. How would you safely rerun only the failed file in the real operation?
5. What should the Linux receiver do if the same XLS file arrives twice?
