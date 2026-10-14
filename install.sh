#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ID="net.xaihi.spanningwallpaper"
PLUGIN_DIR="$SCRIPT_DIR/$PLUGIN_ID"
KPACKAGE_TYPE="Plasma/Wallpaper"

GLOBAL=false

parse_global_flag() {
  for arg in "$@"; do
    case "$arg" in
    --global) GLOBAL=true ;;
    *)
      echo "error: unknown option '$arg'" >&2
      exit 1
      ;;
    esac
  done
}

require_root_for_global() {
  if $GLOBAL && [[ $EUID -ne 0 ]]; then
    echo "error: --global installs system-wide (under /usr/share), which requires root." >&2
    echo "Re-run as: sudo $0 $COMMAND --global" >&2
    exit 1
  fi
}

is_installed() {
  kpackagetool6 --type "$KPACKAGE_TYPE" --list 2>/dev/null | grep -qx "$PLUGIN_ID"
}

cmd_install() {
  require_root_for_global
  if [[ ! -d "$PLUGIN_DIR" ]]; then
    echo "error: plugin source not found at $PLUGIN_DIR" >&2
    exit 1
  fi

  local kpkg_args=(--type "$KPACKAGE_TYPE")
  $GLOBAL && kpkg_args+=(--global)

  if kpackagetool6 "${kpkg_args[@]}" --install "$PLUGIN_DIR" 2>/dev/null; then
    return
  fi
  kpackagetool6 "${kpkg_args[@]}" --upgrade "$PLUGIN_DIR"
}

cmd_uninstall() {
  require_root_for_global
  local kpkg_args=(--type "$KPACKAGE_TYPE")
  $GLOBAL && kpkg_args+=(--global)

  kpackagetool6 "${kpkg_args[@]}" --remove "$PLUGIN_ID"
}

cmd_status() {
  if is_installed; then
    echo "$PLUGIN_ID is installed."
  else
    echo "$PLUGIN_ID is not installed."
  fi
}

COMMAND="${1:-}"
case "$COMMAND" in
install)
  shift
  parse_global_flag "$@"
  cmd_install
  ;;
uninstall)
  shift
  parse_global_flag "$@"
  cmd_uninstall
  ;;
status)
  shift
  parse_global_flag "$@"
  cmd_status
  ;;
*)
  echo "Usage: $0 {install|uninstall|status} [--global]" >&2
  exit 1
  ;;
esac
