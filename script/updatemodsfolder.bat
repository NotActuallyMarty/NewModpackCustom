@echo off
setlocal

cd /d "%~dp0"

set "REPO_URL=https://github.com/NotActuallyMarty/NewModpackCustom.git"
set "BRANCH=main"
set "TEMP_DIR=_temp_repo_clone"
set "script_dir=script"
set "GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.51.2.windows.1/Git-2.51.2-64-bit.exe"

git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed or not found in PATH.
    echo Please install Git, then re-run this script.
    echo Press enter to download git.exe
    echo.
    pause
    echo Opening Git download page...
    start "" "%GIT_URL%"
    echo.
    echo Please install Git, then re-run this script.
    echo Please install Git, then re-run this script.
    echo Please install Git, then re-run this script.
    pause
    exit /b
)



if not exist ".git" (
    echo Repository not found here.
    echo Do you want to install the repository here? Your directory should be the modpack folder (outside of mods!!)
    set /p start=Enter your choice [y / n]:
    if "%start%"=="n"||"N" goto exit
    if "%start%"=="y"||"Y" goto continue
    echo Invalid choice. Try again.
    :continue
    git clone -b %BRANCH% %REPO_URL% "%TEMP_DIR%"
    echo Moving repository contents to current directory...
    xcopy "%TEMP_DIR%\*" ".\" /E /H /K /Y >nul
    echo Cleaning up temporary folder...
    rmdir /S /Q "%TEMP_DIR%"
)

echo [INFO] Moving new script here (for the first time)
xcopy "%script_dir%\*" ".\" /E /H /K /Y >nul


:menu
echo.
echo =======================================================================
echo Marty's totally cool mod updater that isn't just a disguised git repo
echo =======================================================================
echo [1] Download new mods, resourcepacks, shaderpacks.
echo _______________________________________________________________________
echo [2] Full sync
echo - WARNING -
echo This will delete *YOUR* custom mods, resourcepacks, shaderpacks
echo _______________________________________________________________________
echo [3] Clean mods folder only
echo _______________________________________________________________________
echo [4] Exit
echo =======================================================================
set /p choice=Enter your choice [1-4]: 

if "%choice%"=="1" goto pull
if "%choice%"=="2" goto sync
if "%choice%"=="3" goto modsonly
if "%choice%"=="4" goto exit
echo Invalid choice. Try again.
goto menu

:pull
echo.
echo Pulling latest changes from "%BRANCH%"...
git pull origin %BRANCH%
echo [INFO] Moving new script here
xcopy "%script_dir%\*" ".\" /E /H /K /Y >nul

echo.
echo [DONE!] Pull complete.
echo If you continue the menu will open again
echo otherwise, it is safe to close.
pause
goto menu

:modsonly
echo.
echo Cleaning untracked files in 'mods' folder...
if exist "mods" (
    git clean -fd mods
    echo 'mods' folder cleaned.
)
goto pull


:sync
echo.
echo Syncing repository with remote branch "%BRANCH%"...
git clean -fd
git fetch origin %BRANCH%
git checkout -B %BRANCH% origin/%BRANCH%
git reset --hard origin/%BRANCH%
git clean -fd
echo [INFO] Moving new script here
xcopy "%script_dir%\*" ".\" /E /H /K /Y >nul

echo.
echo [DONE!] Repository synced successfully.
echo If you continue the menu will open again
echo otherwise, it is safe to close.
pause
goto menu

:exit
echo Exiting...
endlocal
exit /b
