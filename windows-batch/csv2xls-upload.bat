@echo off
setlocal EnableExtensions

rem 10-file CSV -> XLS -> FTP transfer job.
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
rem UPLOAD_MODE=ftp uses the traditional Windows ftp.exe command file.
if "%UPLOAD_MODE%"=="" set "UPLOAD_MODE=simulate"
if "%FTP_HOST%"=="" set "FTP_HOST="
if "%FTP_USER%"=="" set "FTP_USER="
if "%FTP_PASSWORD%"=="" set "FTP_PASSWORD="
if "%FTP_TARGET%"=="" set "FTP_TARGET="

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

if /I "%UPLOAD_MODE%"=="ftp" goto :upload_ftp

copy /Y "%XLS_FILE%" "%SIMULATED_REMOTE%\" >nul
if errorlevel 1 (
  echo [%JOB_ID%] Linux送信シミュレーション失敗
  exit /b 45
)
echo [%JOB_ID%] Linux送信シミュレーション完了
exit /b 0

:upload_ftp
if "%FTP_HOST%"=="" (
  echo [%JOB_ID%] FTP_HOSTが設定されていません
  exit /b 46
)
if "%FTP_USER%"=="" (
  echo [%JOB_ID%] FTP_USERが設定されていません
  exit /b 46
)
if "%FTP_PASSWORD%"=="" (
  echo [%JOB_ID%] FTP_PASSWORDが設定されていません
  exit /b 46
)
if "%FTP_TARGET%"=="" (
  echo [%JOB_ID%] FTP_TARGETが設定されていません
  exit /b 46
)

set "FTP_COMMAND_FILE=%TEMP%\night-batch-%JOB_ID%.ftp"
>"%FTP_COMMAND_FILE%" echo open %FTP_HOST%
>>"%FTP_COMMAND_FILE%" echo user %FTP_USER% %FTP_PASSWORD%
>>"%FTP_COMMAND_FILE%" echo binary
>>"%FTP_COMMAND_FILE%" echo cd %FTP_TARGET%
>>"%FTP_COMMAND_FILE%" echo lcd %XLS_DIR%
>>"%FTP_COMMAND_FILE%" echo put %JOB_ID%.xls
>>"%FTP_COMMAND_FILE%" echo bye

ftp -n -s:"%FTP_COMMAND_FILE%"
set "FTP_RC=%ERRORLEVEL%"
del /Q "%FTP_COMMAND_FILE%" >nul 2>&1
if not "%FTP_RC%"=="0" (
  echo [%JOB_ID%] Linux FTP転送失敗: RC=%FTP_RC%
  exit /b 46
)
echo [%JOB_ID%] Linux FTP転送完了
exit /b 0

:error
echo CSV2XLS・Linux転送ジョブ異常終了。直前のジョブ番号を確認してください。
exit /b 47
