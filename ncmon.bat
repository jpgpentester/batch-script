@echo off

Rem Network Connection Monitoring Tool
Rem Version: 1.4
Rem Purpose: Simple script that display current established connection every 3 seconds and create a log including with date and time stamp.
Rem Author: Jose Paulo Garcia
Rem Email: josepaulogarcia.career{at}protonmail{period}com
Rem Date Created: 23Jan2023 13:07
Rem Date Modified: 25Jan2023 20:10
Rem Issues: Date and time issues where it doesnt include zero leading digits


echo ############################################################
echo ############################################################
echo ####                                                    ####
echo ####                                                    ####
echo ####                                                    ####
echo ####                                                    ####
echo ####  (N)etwork (C)onnection (MON)itoring Tool v.1.2.0  ####
echo ####                                                    ####
echo ####                                                    ####
echo ####                                                    ####
echo ####            Author: Jose Paulo Garcia               ####
echo ####                                                    ####
echo ####                                                    ####
echo ####                                                    ####
echo ############################################################
echo ############################################################

Rem Clear screen
cls

Rem Date format if needed
set DD=%date:~7, 2%
set MM=%date:~4, 2%
set YYYY=%date:~10, 4%

Rem Time format if needed
set HH=%time:~0, 2%
set MM=%time:~3, 2%
set SS=%time:~6, 2%

Rem Variables
set /A DATESTAMP=%DD%%MM%%YYYY%
set /A TIMESTAMP=%HH%%MM%%SS%
set FILEPATH=%USERPROFILE%\Documents\Log\

Rem Below checks variable for date, time, directory and file name
Rem echo Current Date: %DATESTAMP%
Rem echo Current Time: %TIMESTAMP%
Rem echo File Path: %FILEPATH%
Rem echo 1 %FILEPATH%ncom-security-log-%DATESTAMP%-%TIMESTAMP%.txt

Rem If needed user input for filename uncomment below by removing Rem
Rem set /p input = Please type the file name below:

Rem Redirect from system directory
cd %USERPROFILE%\Documents\

Rem Create directory for logs
if exist Log (
    echo.
    echo [INFO] Log directory already exists.
    call :CHECK_ERROR_CODE %ERRORLEVEL%, "Log directory creation - "
) else (
    echo.
    mkdir Log
    echo [INFO] Log directory was successfully created.
    call :CHECK_ERROR_CODE %ERRORLEVEL%, "Log directory creation - "
)

echo [INFO] PATH: '%FILEPATH%'
echo [INFO] Network security logging started.
echo.
echo Hit control + c to cancel...
timeout 10

for /l %%x in (1, 1, 10000) do (
    echo.
    call :GET_DATE_TIME
    netstat -ano | findstr EST
    
    Rem Prints out variable in debugging mode
    Rem echo 1 %FILEPATH%ncom-security-log-%DATESTAMP%-%TIMESTAMP%.txt

    call :GET_DATE_TIME >> %FILEPATH%ncom-security-log-%DATESTAMP%-%TIMESTAMP%.txt
    netstat -ano | findstr EST >> %FILEPATH%ncom-security-log-%DATESTAMP%-%TIMESTAMP%.txt
    echo. >> %FILEPATH%ncom-security-log-%DATESTAMP%-%TIMESTAMP%.txt
    echo.

    for /l %%x in (3, -1, 1) do (
        echo Scanning for current connections in %%x ....
        timeout 1 > nul
    )
)

echo.
echo.
echo Shutting down in 1 minute please re-run the program.
echo Hit control + c to close
timeout 60


Rem FUNCTION DECLARATION
:CHECK_ERROR_CODE
if %~1 neq 0 (
    echo.
    echo [WARNING]: %~2 Failed. Encountered error. %~1
)
EXIT /B 0

:GET_DATE_TIME
echo %DATE% %TIME%
EXIT /B 0
