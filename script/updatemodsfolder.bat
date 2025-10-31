@echo off
setlocal
set "REPO_URL=https://github.com/NotActuallyMarty/NewModpackCustom.git"
set "DUMMY_BRANCH=dummybranch"
set "MAIN_BRANCH=main"
set "TEMP_DIR=_temp_repo_clone"
set "script_dir=script"

if not exist ".git" (
    echo [INFO] No repository found. Cloning dummy branch shallowly into temporary folder...
    git clone --branch %DUMMY_BRANCH% --single-branch --depth 1 %REPO_URL% "%TEMP_DIR%"
    if errorlevel 1 (
        echo [ERROR] Failed to clone dummy branch. Exiting.
        pause
        exit /b 1
    )

    echo [INFO] Moving dummy repository contents to current directory...
    xcopy "%TEMP_DIR%\*" ".\" /E /H /K /Y >nul

    echo [INFO] Cleaning up temporary folder...
    rmdir /S /Q "%TEMP_DIR%"

    echo [INFO] Fetching and switching to "%MAIN_BRANCH%" branch...
    git fetch origin %MAIN_BRANCH% --depth 1
    git checkout -B %MAIN_BRANCH%
    git pull origin %MAIN_BRANCH% --allow-unrelated-histories
) else (
    echo [INFO] Repository already exists. Pulling latest changes from "%MAIN_BRANCH%"...
    git pull origin %MAIN_BRANCH%
)

echo [INFO] Moving new script here
    xcopy "%script_dir%\*" ".\" /E /H /K /Y >nul

echo.
echo [DONE] Repository updated successfully.
pause