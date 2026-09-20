@echo off
rem Load KEY=VALUE pairs from a shared Batch configuration file.
rem Only NIGHT_* and CSV2XLS_* variables are accepted.
rem @ROOT@ and @DATE@ are expanded by the caller before this file is called.

set "CONFIG_FILE=%~1"
if "%CONFIG_FILE%"=="" exit /b 90
if not exist "%CONFIG_FILE%" exit /b 91

for /f "usebackq eol=# tokens=* delims=" %%A in ("%CONFIG_FILE%") do (
  set "CONFIG_LINE=%%A"
  for /f "tokens=1,* delims==" %%K in ("!CONFIG_LINE!") do (
    set "CONFIG_KEY=%%K"
    set "CONFIG_VALUE=%%L"
    set "CONFIG_VALUE=!CONFIG_VALUE:@ROOT@=%ROOT%!"
    set "CONFIG_VALUE=!CONFIG_VALUE:@DATE@=%BUSINESS_DATE%!"
    if /I "!CONFIG_KEY:~0,6!"=="NIGHT_" set "!CONFIG_KEY!=!CONFIG_VALUE!"
    if /I "!CONFIG_KEY:~0,8!"=="CSV2XLS_" set "!CONFIG_KEY!=!CONFIG_VALUE!"
  )
)
exit /b 0
