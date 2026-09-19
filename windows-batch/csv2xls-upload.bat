@echo off
setlocal EnableExtensions

rem 10-file CSV -> XLS -> Linux transfer job.
rem Deliberately written as ten explicit calls. Do not replace this with a FOR
rem loop: the real operation uses individually coded job steps and return-code
rem checks so an operator can identify the failed file immediately.

set "ROOT=%~dp0.."
set "CSV_DIR=%ROOT%\data\input\csv"
set "XLS_DIR=%ROOT%\data\output\xls"
set "SIMULATED_REMOTE=%ROOT%\data\remote\linux"

rem Place the site-provided converter here, or override this variable.
set "CSV2XLS_JS=%CSV2XLS_JS%"
if "%CSV2XLS_JS%"=="" set "CSV2XLS_JS=%~dp0CSV2XLS.js"

rem UPLOAD_MODE=simulate is safe for this training repository.
rem UPLOAD_MODE=ssh requires a configured OpenSSH client and key agent.
if "%UPLOAD_MODE%"=="" set "UPLOAD_MODE=simulate"
if "%LINUX_HOST%"=="" set "LINUX_HOST=operator@linux-training-host"
if "%LINUX_TARGET%"=="" set "LINUX_TARGET=/var/tmp/night-batch-lab/xls"

if not exist "%XLS_DIR%" mkdir "%XLS_DIR%"
if not exist "%SIMULATED_REMOTE%" mkdir "%SIMULATED_REMOTE%"

if not exist "%CSV2XLS_JS%" (
  echo CSV2XLS.js がありません: %CSV2XLS_JS%
  echo サイト提供の変換スクリプトを配置するか CSV2XLS_JS を設定してください。
  exit /b 41
)

call :convert_and_upload 000000001
if errorlevel 1 goto :error
call :convert_and_upload 000000002
if errorlevel 1 goto :error
call :convert_and_upload 000000003
if errorlevel 1 goto :error
call :convert_and_upload 000000004
if errorlevel 1 goto :error
call :convert_and_upload 000000005
if errorlevel 1 goto :error
call :convert_and_upload 000000006
if errorlevel 1 goto :error
call :convert_and_upload 000000007
if errorlevel 1 goto :error
call :convert_and_upload 000000008
if errorlevel 1 goto :error
call :convert_and_upload 000000009
if errorlevel 1 goto :error
call :convert_and_upload 000000010
if errorlevel 1 goto :error

echo 10件のCSV変換・転送が完了しました。
exit /b 0

:convert_and_upload
set "JOB_ID=%~1"
set "CSV_FILE=%CSV_DIR%\%JOB_ID%.csv"
set "XLS_FILE=%XLS_DIR%\%JOB_ID%.xls"

if not exist "%CSV_FILE%" (
  echo 入力CSVがありません: %CSV_FILE%
  exit /b 42
)

echo [%JOB_ID%] CSV2XLS.js 開始
node "%CSV2XLS_JS%" "%CSV_FILE%" "%XLS_FILE%"
if errorlevel 1 (
  echo [%JOB_ID%] CSV2XLS.js 異常終了
  exit /b 43
)
if not exist "%XLS_FILE%" (
  echo [%JOB_ID%] XLSが生成されていません
  exit /b 44
)

if /I "%UPLOAD_MODE%"=="ssh" goto :upload_ssh

copy /Y "%XLS_FILE%" "%SIMULATED_REMOTE%\" >nul
if errorlevel 1 (
  echo [%JOB_ID%] Linux送信シミュレーション失敗
  exit /b 45
)
echo [%JOB_ID%] Linux送信シミュレーション完了
exit /b 0

:upload_ssh
scp "%XLS_FILE%" "%LINUX_HOST%:%LINUX_TARGET%/"
if errorlevel 1 (
  echo [%JOB_ID%] Linux scp転送失敗
  exit /b 46
)
echo [%JOB_ID%] Linux scp転送完了
exit /b 0

:error
echo CSV2XLS・Linux転送ジョブ異常終了。直前のジョブ番号を確認してください。
exit /b 47
