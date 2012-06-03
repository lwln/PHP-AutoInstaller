@ECHO OFF
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "Path" /t REG_EXPAND_SZ /d "%PATH%;%HOMEDRIVE%\php" /f
cls
echo Succesfully edited path.
pause

mkdir temp
bins\wget -P temp/ http://www.yufexa.com/test/phplist/
cls
bins\cat temp/index.html > temp/tmpFile
set /p tmpVar=<temp/tmpFile
cls
bins\wget %tmpVar%
cls
rd /s /q temp
mkdir php
bins\7za x -ophp *.zip
del *.zip
copy config\php.ini php\php.ini

cls
echo Press 'D'
mkdir %HOMEDRIVE%\php
xcopy php "%HOMEDRIVE%\php" /S
rd /s /q php

:end
cls
echo Succesfully completed.
echo You will have to restart your computer at your own discretion. Thank you.
pause