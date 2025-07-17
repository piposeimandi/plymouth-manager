#!/bin/bash
# plym.sh - Plymouth Manager
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


set -eu  # fail on error or unbound variable

# Color codes
C_NC='\033[0m'
C_GREEN='\033[0;32m'
C_RED="\033[0;31m"
PLYM_DIR="/usr/share/plymouth/themes"

# Check dependencies
function require_cmd {
    for cmd in "$@"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "${C_RED}ERROR:${C_NC} Required command '$cmd' not found."
            exit 2
        fi
    done
}
require_cmd update-alternatives update-initramfs plymouth plymouthd

function p_main {
    local cmd="${1:-help}"
    shift || true
    case "$cmd" in
        list)    p_list ;;
        install) p_install "$@" ;;
        select)  p_select ;;
        preview) p_preview "$@" ;;
        help|--help|-h) p_help ;;
        *)       p_help ;;
    esac
}

function p_help {
    cat <<EOF
Plymouth theme manager
Usage: ${0} [COMMAND] [args...]

Available commands:
  list             List installed Plymouth themes
  install THEME    Install and set THEME as default
  select           Select theme interactively
  preview [SEC]    Preview current theme (default: 5 sec)
  help             Show this help
EOF
    exit 0
}

function p_list {
    local themes
    themes=$(ls -1 "${PLYM_DIR}")
    local current_theme
    current_theme=$(readlink -f /etc/alternatives/default.plymouth 2>/dev/null || echo "")
    echo "List of Plymouth themes:"
    for i in $themes; do
        # Skip files
        if [ ! -d "${PLYM_DIR}/${i}" ]; then continue; fi
        if [[ "$current_theme" == "${PLYM_DIR}/${i}/${i}.plymouth" ]]; then
            printf "${C_GREEN} - %s (current)${C_NC}\n" "$i"
        else
            echo " - $i"
        fi
    done
}

function p_install {
    local theme_name="${1:-}"
    if [ -z "$theme_name" ]; then
        p_throw "Please specify theme name"
        exit 1
    fi

    local thm_file="${PLYM_DIR}/${theme_name}/${theme_name}.plymouth"
    if [ ! -f "$thm_file" ]; then
        p_throw "Theme '$theme_name' not found ($thm_file)"
        p_list
        exit 1
    fi

    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth "$thm_file" 100
    echo "Theme '$theme_name' installed. Use 'select' to activate."
}

function p_select {
    sudo update-alternatives --config default.plymouth
    sudo update-initramfs -u
    echo "Theme selected and initramfs updated."
}

function p_preview {
    local sec="${1:-5}"
    if [ "$(id -u)" -ne 0 ]; then
        p_throw "Must be run as root"
        exit 1
    fi
    plymouthd
    plymouth --show-splash
    for ((i=0; i<sec; i++)); do
        plymouth --update="test$i"
        sleep 1
    done
    plymouth quit
}

function p_throw {
    printf "${C_RED}ERROR:${C_NC} %s\n" "$1" >&2
}

p_main "$@"
