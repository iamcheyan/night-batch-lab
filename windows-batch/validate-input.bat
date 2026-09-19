@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "INPUT_FILE=%~1"
if "%INPUT_FILE%"=="" (
  echo 使用方法: validate-input.bat INPUT_FILE
  exit /b 10
)

if not exist "%INPUT_FILE%" (
  echo 入力ファイルがありません: %INPUT_FILE%
  exit /b 11
)

for %%A in ("%INPUT_FILE%") do if %%~zA EQU 0 (
  echo 入力ファイルが空です: %INPUT_FILE%
  exit /b 12
)

echo 入力ファイル確認完了: %INPUT_FILE%
exit /b 0
