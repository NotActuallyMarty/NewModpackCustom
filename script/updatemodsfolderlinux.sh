#!/usr/bin/env bash

set -e

# Change to the directory of the script
cd "$(dirname "$0")"

REPO_URL="https://github.com/NotActuallyMarty/NewModpackCustom.git"
BRANCH="main"
TEMP_DIR="_temp_repo_clone"
SCRIPT_DIR="script"

# --- Git check ---
if ! command -v git >/dev/null 2>&1; then
    echo "[ERROR] Git is not installed."
    echo "Install Git with:"
    echo "    sudo dnf install git"
    exit 1
fi

# --- Clone repo if .git missing ---
if [[ ! -d ".git" ]]; then
    echo "Repository not found here. Cloning into temporary folder..."
    git clone -b "$BRANCH" "$REPO_URL" "$TEMP_DIR"

    echo "Moving repository contents to current directory..."
    cp -r "$TEMP_DIR"/* ./

    echo "Cleaning up temporary folder..."
    rm -rf "$TEMP_DIR"
fi

echo "[INFO] Syncing script directory..."
cp -r "$SCRIPT_DIR"/* ./ 2>/dev/null || true

# -----------------------------------------------------------
# Menu function
# -----------------------------------------------------------
menu() {
    echo
    echo "======================================================================="
    echo "Marty's totally cool mod updater that isn't just a disguised git repo"
    echo "======================================================================="
    echo "[1] Download new mods, resourcepacks, shaderpacks."
    echo "-----------------------------------------------------------------------"
    echo "[2] Full sync"
    echo "   - WARNING - This will delete *YOUR* custom mods, resourcepacks, shaderpacks."
    echo "-----------------------------------------------------------------------"
    echo "[3] Clean mods folder only"
    echo "-----------------------------------------------------------------------"
    echo "[4] Exit"
    echo "======================================================================="
    echo -n "Enter your choice [1-4]: "
    read choice

    case "$choice" in
        1) pull ;;
        2) sync_repo ;;
        3) modsonly ;;
        4) exit_script ;;
        *)
            echo "Invalid choice. Try again."
            menu
            ;;
    esac
}

# -----------------------------------------------------------
# Pull function
# -----------------------------------------------------------
pull() {
    echo
    echo "Pulling latest changes from '$BRANCH'..."
    git pull origin "$BRANCH"

    echo "[INFO] Updating script directory..."
    cp -r "$SCRIPT_DIR"/* ./ 2>/dev/null || true

    echo
    echo "[DONE!] Pull complete."
    echo "Press Enter to return to menu."
    read
    menu
}

# -----------------------------------------------------------
# Clean mods only
# -----------------------------------------------------------
modsonly() {
    echo
    echo "Cleaning untracked files in 'mods' folder..."

    if [[ -d "mods" ]]; then
        git clean -fd mods
        echo "'mods' folder cleaned."
    else
        echo "'mods' folder does not exist."
    fi

    pull
}

# -----------------------------------------------------------
# Full sync
# -----------------------------------------------------------
sync_repo() {
    echo
    echo "Syncing repository with remote branch '$BRANCH'..."

    git clean -fd
    git fetch origin "$BRANCH"
    git checkout -B "$BRANCH" "origin/$BRANCH"
    git reset --hard "origin/$BRANCH"
    git clean -fd

    echo "[INFO] Updating script directory..."
    cp -r "$SCRIPT_DIR"/* ./ 2>/dev/null || true

    echo
    echo "[DONE!] Repository synced successfully."
    echo "Press Enter to return to menu."
    read
    menu
}

# -----------------------------------------------------------
# Exit
# -----------------------------------------------------------
exit_script() {
    echo "Exiting..."
    exit 0
}

# Start menu
menu
