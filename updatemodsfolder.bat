@echo off
setlocal

set REPO_URL=https://github.com/NotActuallyMarty/NewModpackCustom.git

set BRANCH=main
set TEMP_DIR=_temp_repo_clone

if not exist ".git" (
    echo Repository not found here. Cloning into temporary folder...
    git clone -b %BRANCH% %REPO_URL% "%TEMP_DIR%"
    echo Moving repository contents to current directory...
    xcopy "%TEMP_DIR%\*" ".\" /E /H /K /Y
    echo Cleaning up...
    rmdir /S /Q "%TEMP_DIR%"
) else (
    echo Repository already exists. Pulling latest changes...
    git pull origin %BRANCH%
)

echo.
echo Mods updated.
pause
