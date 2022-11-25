#!/bin/sh
# This file is part of Itsnexn's dotfiles.
#
# Repository: https://github.com/itsnexn/dotfiles
# LICENSE:    MIT (https://opensource.org/licenses/MIT)

SCRIPT_DIR="$HOME/.config/mpv/scripts/"

get_script() {
    MODE="$1"
    URL="$2"
    LOC="$3"
    NAME="$(basename "$URL")"
    DOWNLOAD=0

    echo "[*] Downloading $NAME"
    if [ -e "${SCRIPT_DIR}${LOC:-$NAME}" ]; then
        printf "[!] %s already exists. overwrite? [y/n] " "$NAME"
        read -r ans
        [ "$ans" = "y" ] && DOWNLOAD=1
    else
        DOWNLOAD=1
    fi

    if [ "$DOWNLOAD" -ne 0 ]; then
        case $MODE in
            http) curl -sL "$URL" -o "${SCRIPT_DIR}${LOC:-$NAME}";;
            git) git clone -q "$URL" "${SCRIPT_DIR}${LOC:-$NAME}";;
        esac
    fi
}

download_scripts() {
    echo "[*] ===== Downloading userscripts"
    GH_RAW="https://raw.githubusercontent.com"

    get_script "http" "${GH_RAW}/Zren/mpv-osc-tethys/master/osc_tethys.lua"
    get_script "http" \
        "${GH_RAW}/Zren/mpv-osc-tethys/master/mpv_thumbnail_script_server.lua"
    get_script "http" "${GH_RAW}/mpv-player/mpv/master/TOOLS/lua/autoload.lua"

    get_script "git" "https://github.com/Ajatt-Tools/autosubsync-mpv" \
        "autosubsync"

    get_script "http" "${GH_RAW}/kelciour/mpv-scripts/master/sub-cut.lua"
    get_script "http" "${GH_RAW}/CogentRedTester/mpv-file-browser/master/file-browser.lua"
}

install_dependencies() {
    echo "[*] ===== Installing dependencies"
    if ! command -v ffsubsync 1> /dev/null 2>&1; then
        echo "[*] Installing ffsubsync"
        pip install -q ffsubsync
    fi

    if ! command -v ffmpeg 1> /dev/null 2>&1; then
        echo "[*] Installing ffmpeg"
        sudo pacman -S ffmpeg
    fi
}

check_script_dir() {
    if ! [ -d "$SCRIPT_DIR" ]; then
        echo "[*] Creating Script Directory"
        mkdir -p "$SCRIPT_DIR"
    fi
}

main() {
    check_script_dir
    download_scripts
    install_dependencies
    echo "[*] DONE!"
}

main
