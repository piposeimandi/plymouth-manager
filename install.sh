#!/bin/sh
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
