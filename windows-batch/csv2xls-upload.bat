@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem 10-file CSV -> XLS -> FTP transfer job.
rem
rem This is intentionally old-fashioned training code: labels, CALL,
rem subroutines, nested FOR checks, delayed expansion, ERRORLEVEL, status
rem files, explicit return codes, retry-safe output handling, and Japanese
rem operator messages.
rem
rem The preflight FOR loop checks all inputs. The ten conversion and upload
rem steps remain explicit because each real job step needs its own checkpoint.

if /I "%~1"=="/?" goto :usage
if /I "%~1"=="help" goto :usage

set "ROOT=%~dp0.."
set "CONFIG_FILE=%~dp0night-batch.conf"
call "%~dp0load-config.bat" "%CONFIG_FILE%"
if errorlevel 1 (
  echo 設定ファイルを読み込めません: %CONFIG_FILE%
  exit /b 10
)
if not "%~2"=="" (
  set "CONFIG_FILE=%~2"
  call "%~dp0load-config.bat" "%CONFIG_FILE%"
  if errorlevel 1 (
    echo 外部設定ファイルを読み込めません: %CONFIG_FILE%
    exit /b 10
  )
)
set "ROOT=%NIGHT_ROOT%"
set "CSV_DIR=%CSV2XLS_CSV_DIR%"
set "XLS_DIR=%CSV2XLS_XLS_DIR%"
set "SIMULATED_REMOTE=%CSV2XLS_REMOTE_DIR%"
set "ARCHIVE_ROOT=%CSV2XLS_ARCHIVE_ROOT%"
set "LOG_DIR=%CSV2XLS_LOG_DIR%"
set "STATUS_DIR=%CSV2XLS_STATUS_DIR%"

set "BUSINESS_DATE=%~1"
if "%BUSINESS_DATE%"=="" set "BUSINESS_DATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%"
set "LOG_FILE=%LOG_DIR%\csv2xls-%BUSINESS_DATE%.log"
set "STATUS_FILE=%STATUS_DIR%\csv2xls-%BUSINESS_DATE%.status"
set "ARCHIVE_DIR=%ARCHIVE_ROOT%\%BUSINESS_DATE%"

rem Place the site-provided converter here, or override this variable.
set "CSV2XLS_JS=%CSV2XLS_CONVERTER%"

rem simulate is safe for this training repository.
rem ftp uses the traditional Windows ftp.exe command file.
set "UPLOAD_MODE=%CSV2XLS_UPLOAD_MODE%"
set "CONTINUE_ON_ERROR=%CSV2XLS_CONTINUE_ON_ERROR%"
set "OVERWRITE_OUTPUT=%CSV2XLS_OVERWRITE_OUTPUT%"
set "FTP_HOST=%CSV2XLS_FTP_HOST%"
set "FTP_USER=%CSV2XLS_FTP_USER%"
set "FTP_PASSWORD=%CSV2XLS_FTP_PASSWORD%"
set "FTP_TARGET=%CSV2XLS_FTP_TARGET%"

set /a SUCCESS_COUNT=0
set /a ERROR_COUNT=0
set /a SKIP_COUNT=0
set "CURRENT_JOB=STARTUP"

call :prepare_directories
if errorlevel 1 goto :fatal_error
call :write_log "JOB START date=%BUSINESS_DATE% mode=%UPLOAD_MODE% continue=%CONTINUE_ON_ERROR% overwrite=%OVERWRITE_OUTPUT%"
>"%STATUS_FILE%" echo JOB_DATE=%BUSINESS_DATE%
>>"%STATUS_FILE%" echo JOB_MODE=%UPLOAD_MODE%
>>"%STATUS_FILE%" echo JOB_STATUS=STARTED

call :validate_configuration
if errorlevel 1 goto :fatal_error
call :preflight_inputs
if errorlevel 1 goto :fatal_error

rem Explicitly coded production-style job steps. Keep the repetition.
call :process_job 000000001
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_001
call :process_job 000000002
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_002
call :process_job 000000003
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_003
call :process_job 000000004
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_004
call :process_job 000000005
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_005
call :process_job 000000006
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_006
call :process_job 000000007
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_007
call :process_job 000000008
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_008
call :process_job 000000009
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_009
call :process_job 000000010
if errorlevel 1 if /I not "%CONTINUE_ON_ERROR%"=="Y" goto :job_error
:next_job_010

>>"%STATUS_FILE%" echo JOB_STATUS=FINISHED
call :write_log "JOB END success=!SUCCESS_COUNT! error=!ERROR_COUNT! skip=!SKIP_COUNT!"
if not "!ERROR_COUNT!"=="0" goto :job_error
echo 10件のCSV変換・転送が完了しました。成功=!SUCCESS_COUNT!件
exit /b 0

:prepare_directories
if not exist "%XLS_DIR%" mkdir "%XLS_DIR%"
if errorlevel 1 exit /b 31
if not exist "%SIMULATED_REMOTE%" mkdir "%SIMULATED_REMOTE%"
if errorlevel 1 exit /b 31
if not exist "%ARCHIVE_DIR%" mkdir "%ARCHIVE_DIR%"
if errorlevel 1 exit /b 31
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if errorlevel 1 exit /b 31
if not exist "%STATUS_DIR%" mkdir "%STATUS_DIR%"
if errorlevel 1 exit /b 31
exit /b 0

:validate_configuration
if /I not "%UPLOAD_MODE%"=="simulate" if /I not "%UPLOAD_MODE%"=="ftp" (
  call :write_log "CONFIG ERROR: UPLOAD_MODEはsimulateまたはftp"
  exit /b 32
)
if /I not "%CONTINUE_ON_ERROR%"=="Y" if /I not "%CONTINUE_ON_ERROR%"=="N" exit /b 32
if /I not "%OVERWRITE_OUTPUT%"=="Y" if /I not "%OVERWRITE_OUTPUT%"=="N" exit /b 32
if not exist "%CSV2XLS_JS%" (
  call :write_log "CONFIG ERROR: CSV2XLS.jsがありません: %CSV2XLS_JS%"
  exit /b 41
)
if /I "%UPLOAD_MODE%"=="ftp" (
  if "%FTP_HOST%"=="" exit /b 46
  if "%FTP_USER%"=="" exit /b 46
  if "%FTP_PASSWORD%"=="" exit /b 46
  if "%FTP_TARGET%"=="" exit /b 46
)
exit /b 0

:preflight_inputs
set "PREFLIGHT_RC=0"
call :write_log "PRECHECK START: input CSV 10件"
for %%J in (000000001 000000002 000000003 000000004 000000005 000000006 000000007 000000008 000000009 000000010) do (
  set "PREFLIGHT_FILE=%CSV_DIR%\%%J.csv"
  if not exist "!PREFLIGHT_FILE!" (
    call :write_log "PRECHECK ERROR: %%J CSVがありません"
    set "PREFLIGHT_RC=61"
  ) else (
    set "PREFLIGHT_SIZE=0"
    for %%A in ("!PREFLIGHT_FILE!") do set "PREFLIGHT_SIZE=%%~zA"
    if "!PREFLIGHT_SIZE!"=="0" (
      call :write_log "PRECHECK ERROR: %%J CSVが空です"
      set "PREFLIGHT_RC=62"
    ) else (
      call :write_log "PRECHECK OK: %%J size=!PREFLIGHT_SIZE!"
    )
  )
)
if not "%PREFLIGHT_RC%"=="0" exit /b %PREFLIGHT_RC%
call :write_log "PRECHECK END: OK"
exit /b 0

:process_job
set "JOB_ID=%~1"
set "CURRENT_JOB=%JOB_ID%"
set "CSV_FILE=%CSV_DIR%\%JOB_ID%.csv"
set "XLS_FILE=%XLS_DIR%\%JOB_ID%.xls"
call :write_log "[%JOB_ID%] START"

if not exist "%CSV_FILE%" (
  call :job_fail 42 "入力CSVがありません"
  exit /b 42
)
set "CSV_SIZE=0"
for %%A in ("%CSV_FILE%") do set "CSV_SIZE=%%~zA"
if "%CSV_SIZE%"=="0" (
  call :job_fail 42 "入力CSVが空です"
  exit /b 42
)
call :write_log "[%JOB_ID%] INPUT size=%CSV_SIZE%"

if /I "%OVERWRITE_OUTPUT%"=="N" if exist "%XLS_FILE%" (
  call :write_log "[%JOB_ID%] SKIP: 既存XLSを保護しました"
  set /a SKIP_COUNT+=1
  call :write_status SKIPPED 0 "既存XLSを保護"
  exit /b 0
)
if /I "%OVERWRITE_OUTPUT%"=="Y" if exist "%XLS_FILE%" del /Q "%XLS_FILE%"
if exist "%XLS_FILE%" (
  call :job_fail 44 "既存XLSを削除できません"
  exit /b 44
)

call :write_status RUNNING 0 "CSV2XLS開始"
echo [%JOB_ID%] CSV2XLS.js 開始
node "%CSV2XLS_JS%" "%CSV_FILE%" "%XLS_FILE%"
set "CONVERT_RC=%ERRORLEVEL%"
if not "%CONVERT_RC%"=="0" (
  call :job_fail 43 "CSV2XLS.js異常終了 RC=%CONVERT_RC%"
  exit /b 43
)
if not exist "%XLS_FILE%" (
  call :job_fail 44 "XLSが生成されていません"
  exit /b 44
)
set "XLS_SIZE=0"
for %%A in ("%XLS_FILE%") do set "XLS_SIZE=%%~zA"
if "%XLS_SIZE%"=="0" (
  call :job_fail 44 "生成されたXLSが空です"
  exit /b 44
)
call :write_log "[%JOB_ID%] OUTPUT size=%XLS_SIZE%"

call :upload_job
if errorlevel 1 (
  call :job_fail 46 "Linux転送失敗"
  exit /b 46
)
call :archive_job
if errorlevel 1 (
  call :job_fail 47 "アーカイブ失敗"
  exit /b 47
)
set /a SUCCESS_COUNT+=1
call :write_status SUCCESS 0 "変換・転送・保存完了"
call :write_log "[%JOB_ID%] END SUCCESS"
exit /b 0

:upload_job
if /I "%UPLOAD_MODE%"=="ftp" goto :upload_ftp
copy /Y "%XLS_FILE%" "%SIMULATED_REMOTE%\" >nul
if errorlevel 1 exit /b 45
call :write_log "[%JOB_ID%] Linux送信シミュレーション完了"
exit /b 0

:upload_ftp
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
if not "%FTP_RC%"=="0" exit /b 46
call :write_log "[%JOB_ID%] Linux FTP転送完了"
exit /b 0

:archive_job
copy /Y "%CSV_FILE%" "%ARCHIVE_DIR%\%JOB_ID%.csv" >nul
if errorlevel 1 exit /b 1
copy /Y "%XLS_FILE%" "%ARCHIVE_DIR%\%JOB_ID%.xls" >nul
if errorlevel 1 exit /b 1
call :write_log "[%JOB_ID%] archive=%ARCHIVE_DIR%"
exit /b 0

:job_fail
set "FAIL_RC=%~1"
set "FAIL_MESSAGE=%~2"
set /a ERROR_COUNT+=1
call :write_status FAILED %FAIL_RC% "%FAIL_MESSAGE%"
call :write_log "[%CURRENT_JOB%] ERROR RC=%FAIL_RC% %FAIL_MESSAGE%"
exit /b %FAIL_RC%

:write_status
set "STATUS_VALUE=%~1"
set "STATUS_RC=%~2"
set "STATUS_MESSAGE=%~3"
>>"%STATUS_FILE%" echo %CURRENT_JOB%^|%STATUS_VALUE%^|RC=%STATUS_RC%^|%STATUS_MESSAGE%
exit /b 0

:write_log
set "LOG_MESSAGE=%~1"
>>"%LOG_FILE%" echo [%DATE% %TIME%] %LOG_MESSAGE%
echo [%DATE% %TIME%] %LOG_MESSAGE%
exit /b 0

:job_error
call :write_log "JOB ERROR: current=%CURRENT_JOB% success=!SUCCESS_COUNT! error=!ERROR_COUNT! skip=!SKIP_COUNT!"
>>"%STATUS_FILE%" echo JOB_STATUS=FAILED
echo CSV2XLS・Linux転送ジョブ異常終了。current=%CURRENT_JOB% success=!SUCCESS_COUNT! error=!ERROR_COUNT! skip=!SKIP_COUNT!
exit /b 47

:fatal_error
set "FATAL_RC=%ERRORLEVEL%"
if "%FATAL_RC%"=="0" set "FATAL_RC=48"
call :write_log "FATAL ERROR: current=%CURRENT_JOB% RC=%FATAL_RC%"
if exist "%STATUS_FILE%" >>"%STATUS_FILE%" echo JOB_STATUS=FATAL
echo CSV2XLSジョブ事前チェック異常終了。RC=%FATAL_RC%
exit /b %FATAL_RC%

:usage
echo Usage: csv2xls-upload.bat [BUSINESS_DATE]
echo Example: csv2xls-upload.bat 20260919
echo Environment: UPLOAD_MODE=simulate^|ftp, CONTINUE_ON_ERROR=Y^|N, OVERWRITE_OUTPUT=Y^|N
exit /b 0
