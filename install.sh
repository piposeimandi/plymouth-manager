#!/bin/sh
# install.sh - Installer for Plymouth Manager
# Copyright (C) 2020 x1unix
# Copyright (C) 2025 piposeimandi
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
set -euo pipefail

DOWNLOAD_URL="https://raw.githubusercontent.com/piposeimandi/plymouth-manager/main/plym.sh"
TMP_FILE="/tmp/plym.$$"
DEST="/usr/local/bin/plym"

# Check for dependencies
command -v curl >/dev/null 2>&1 || { echo >&2 "ERROR: curl is required but not installed."; exit 1; }
command -v sudo >/dev/null 2>&1 || { echo >&2 "ERROR: sudo is required but not installed."; exit 1; }

cleanup() {
    [ -f "$TMP_FILE" ] && rm -f "$TMP_FILE"
}
trap cleanup EXIT

echo "Downloading plym from $DOWNLOAD_URL..."
if ! curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"; then
    echo "ERROR: Failed to download plym."
    exit 1
fi

chmod +x "$TMP_FILE"
echo "Installing plym to '$DEST' (you may be prompted for your password)..."
sudo mv "$TMP_FILE" "$DEST"
echo "Installation complete!"
echo "You can now run 'plym' from your terminal."
