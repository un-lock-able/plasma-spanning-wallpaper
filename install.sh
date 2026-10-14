#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ID="org.local.spanningwallpaper"
PLUGIN_DIR="$SCRIPT_DIR/$PLUGIN_ID"
KPACKAGE_TYPE="Plasma/Wallpaper"

is_installed() {
    kpackagetool6 --type "$KPACKAGE_TYPE" --list 2>/dev/null | grep -qx "$PLUGIN_ID"
}

cmd_install() {
    if [[ ! -d "$PLUGIN_DIR" ]]; then
        echo "error: plugin source not found at $PLUGIN_DIR" >&2
        exit 1
    fi
    if is_installed; then
        kpackagetool6 --type "$KPACKAGE_TYPE" --upgrade "$PLUGIN_DIR"
    else
        kpackagetool6 --type "$KPACKAGE_TYPE" --install "$PLUGIN_DIR"
    fi
}

cmd_uninstall() {
    if ! is_installed; then
        echo "$PLUGIN_ID is not installed."
        exit 0
    fi
    kpackagetool6 --type "$KPACKAGE_TYPE" --remove "$PLUGIN_ID"
}

cmd_status() {
    if is_installed; then
        echo "$PLUGIN_ID is installed."
    else
        echo "$PLUGIN_ID is not installed."
    fi
}

case "${1:-}" in
    install)   cmd_install ;;
    uninstall) cmd_uninstall ;;
    status)    cmd_status ;;
    *)
        echo "Usage: $0 {install|uninstall|status}" >&2
        exit 1
        ;;
esac
