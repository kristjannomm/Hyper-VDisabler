@ECHO OFF


:: BatchGotAdmin
:-------------------------------------
REM  -->
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> 
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

COLOR 0E
ECHO ==========================
ECHO Hyper-V Disabler
ECHO https://github.com/kristjannomm
ECHO ==========================
:choice
set /P c=Are you sure you want to disable Hyper-V[Y/N]?
if /I "%c%" EQU "Y" goto :yes
if /I "%c%" EQU "N" goto :end
goto :choice


:yes
powershell.exe -Command "bcdedit /set hypervisorlaunchtype off"
powershell.exe -Command "Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor"

ECHO Hyper-V has been fully disabled! Please restart your PC. 
:end
PAUSE
