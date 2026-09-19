@echo off
setlocal EnableExtensions

set "SOURCE_FILE=%~1"
set "REMOTE_DIR=%~2"
if "%SOURCE_FILE%"=="" exit /b 30
if "%REMOTE_DIR%"=="" exit /b 30
if not exist "%SOURCE_FILE%" (
  echo 送信対象がありません: %SOURCE_FILE%
  exit /b 31
)

if not exist "%REMOTE_DIR%" mkdir "%REMOTE_DIR%"
copy /Y "%SOURCE_FILE%" "%REMOTE_DIR%\" >nul
if errorlevel 1 (
  echo 送信シミュレーション失敗
  exit /b 32
)
echo 送信シミュレーション完了
exit /b 0
