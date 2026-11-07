@echo off
set "STAGING_FILE=C:\ProgramData\VTech\DA\Kidizoom\5752_US_eng\Update\APP_DATA.BIN"
set "MY_CUSTOM_BIN=C:\Users\HourTime\Downloads\WatchHacking\Modded BIN\Signed\APP_DATA.bin"

echo Waiting for Learning Lodge to create the update file...

:loop
if exist "%STAGING_FILE%" (
    echo [!] Official file detected! Swapping instantly...
    copy /y "%MY_CUSTOM_BIN%" "%STAGING_FILE%"
    echo [SUCCESS] File replaced. Keep Learning Lodge running!
    pause
    exit
)
goto loop
