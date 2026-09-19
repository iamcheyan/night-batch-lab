@echo off
setlocal EnableExtensions

rem Windows Batch entry point for the same night-batch workflow.
set "ROOT=%~dp0.."
set "BUSINESS_DATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%"
set "INPUT_FILE=%ROOT%\data\input\transactions.csv"
set "OUTPUT_FILE=%ROOT%\data\output\settlement-report.txt"
set "ARCHIVE_DIR=%ROOT%\data\archive\%BUSINESS_DATE%"
set "REMOTE_DIR=%ROOT%\data\remote"
set "LOG_DIR=%ROOT%\logs"
set "LOG_FILE=%LOG_DIR%\nightly-%BUSINESS_DATE%.log"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
call :log 夜間バッチ開始

call "%~dp0validate-input.bat" "%INPUT_FILE%"
if errorlevel 1 goto :error_input

if not exist "%ROOT%\bin\nightsettle.exe" (
  call :log COBOL実行ファイルがありません。先にLinux側でビルドしてください。
  goto :error_cobol
)

set "NIGHT_INPUT=%INPUT_FILE%"
set "NIGHT_OUTPUT=%OUTPUT_FILE%"
"%ROOT%\bin\nightsettle.exe"
if errorlevel 1 goto :error_cobol

if not exist "%OUTPUT_FILE%" goto :error_output
if not exist "%ARCHIVE_DIR%" mkdir "%ARCHIVE_DIR%"
copy /Y "%INPUT_FILE%" "%ARCHIVE_DIR%\transactions.csv" >nul
copy /Y "%OUTPUT_FILE%" "%ARCHIVE_DIR%\settlement-report.txt" >nul
if errorlevel 1 goto :error_archive

call "%~dp0upload-sim.bat" "%OUTPUT_FILE%" "%REMOTE_DIR%"
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
