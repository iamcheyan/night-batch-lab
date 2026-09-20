@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Windows Batch entry point for the same night-batch workflow.
set "ROOT=%~dp0.."
set "BUSINESS_DATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%"
set "CONFIG_FILE=%~dp0night-batch.conf"
call "%~dp0load-config.bat" "%CONFIG_FILE%"
if errorlevel 1 (
  echo 設定ファイルを読み込めません: %CONFIG_FILE%
  exit /b 10
)
if not "%~1"=="" (
  set "CONFIG_FILE=%~1"
  call "%~dp0load-config.bat" "%CONFIG_FILE%"
  if errorlevel 1 (
    echo 外部設定ファイルを読み込めません: %CONFIG_FILE%
    exit /b 10
  )
)
set "ROOT=%NIGHT_ROOT%"
set "INPUT_FILE=%NIGHT_INPUT_FILE%"
set "OUTPUT_FILE=%NIGHT_OUTPUT_FILE%"
set "ARCHIVE_DIR=%NIGHT_ARCHIVE_DIR%"
set "REMOTE_DIR=%NIGHT_REMOTE_DIR%"
set "LOG_DIR=%NIGHT_LOG_DIR%"
set "LOG_FILE=%LOG_DIR%\nightly-%BUSINESS_DATE%.log"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
call :log 夜間バッチ開始

call "%NIGHT_VALIDATE_BAT%" "%INPUT_FILE%"
if errorlevel 1 goto :error_input

if not exist "%NIGHT_COBOL_EXE%" (
  call :log COBOL実行ファイルがありません。先にLinux側でビルドしてください。
  goto :error_cobol
)

set "NIGHT_INPUT=%INPUT_FILE%"
set "NIGHT_OUTPUT=%OUTPUT_FILE%"
"%NIGHT_COBOL_EXE%"
if errorlevel 1 goto :error_cobol

if not exist "%OUTPUT_FILE%" goto :error_output
if not exist "%ARCHIVE_DIR%" mkdir "%ARCHIVE_DIR%"
copy /Y "%INPUT_FILE%" "%ARCHIVE_DIR%\transactions.csv" >nul
copy /Y "%OUTPUT_FILE%" "%ARCHIVE_DIR%\settlement-report.txt" >nul
if errorlevel 1 goto :error_archive

call "%NIGHT_UPLOAD_BAT%" "%OUTPUT_FILE%" "%REMOTE_DIR%"
if errorlevel 1 goto :error_upload

call :log 夜間バッチ正常終了
exit /b 0

:error_input
call :log 入力チェック異常
exit /b 11
:error_cobol
call :log COBOL処理異常
exit /b 21
:error_output
call :log 出力ファイル異常
exit /b 22
:error_archive
call :log アーカイブ異常
exit /b 23
:error_upload
call :log 送信異常
exit /b 31

:log
echo [%DATE% %TIME%] %*>>"%LOG_FILE%"
echo [%DATE% %TIME%] %*
exit /b 0
