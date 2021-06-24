#!/bin/sh

set -e

gh_repo="materia-kde"
gh_desc="Materia KDE"

cat <<- EOF

  ▄▄▄  ▄▄▄                                             ██
  ███  ███              ██                             ▀▀
  ████████   ▄█████▄  ███████    ▄████▄    ██▄████   ████      ▄█████▄
  ██ ██ ██   ▀ ▄▄▄██    ██      ██▄▄▄▄██   ██▀         ██      ▀ ▄▄▄██
  ██ ▀▀ ██  ▄██▀▀▀██    ██      ██▀▀▀▀▀▀   ██          ██     ▄██▀▀▀██
  ██    ██  ██▄▄▄███    ██▄▄▄   ▀██▄▄▄▄█   ██       ▄▄▄██▄▄▄  ██▄▄▄███
  ▀▀    ▀▀   ▀▀▀▀ ▀▀     ▀▀▀▀     ▀▀▀▀▀    ▀▀       ▀▀▀▀▀▀▀▀   ▀▀▀▀ ▀▀

  ▄▄   ▄▄▄  ▄▄▄▄▄     ▄▄▄▄▄▄▄▄
  ██  ██▀   ██▀▀▀██   ██▀▀▀▀▀▀
  ██▄██     ██    ██  ██
  █████     ██    ██  ███████
  ██  ██▄   ██    ██  ██
  ██   ██▄  ██▄▄▄██   ██▄▄▄▄▄▄
  ▀▀    ▀▀  ▀▀▀▀▀     ▀▀▀▀▀▀▀▀

  $gh_desc
  https://github.com/PapirusDevelopmentTeam/$gh_repo


EOF

: "${PREFIX:=/usr}"
: "${TAG:=master}"
: "${uninstall:=false}"

_msg() {
    echo "=>" "$@" >&2
}

_rm() {
    # removes parent directories if empty
    sudo rm -rf "$1"
    sudo rmdir -p "$(dirname "$1")" 2>/dev/null || true
}

_download() {
    _msg "Getting the latest version from GitHub ..."
    wget -O "$temp_file" \
        "https://github.com/PapirusDevelopmentTeam/$gh_repo/archive/$TAG.tar.gz"
    _msg "Unpacking archive ..."
    tar -xzf "$temp_file" -C "$temp_dir"
}

_uninstall() {
    _msg "Deleting $gh_desc ..."
    _rm "$PREFIX/share/aurorae/themes/Materia"
    _rm "$PREFIX/share/aurorae/themes/Materia-Dark"
    _rm "$PREFIX/share/aurorae/themes/Materia-Light"
    _rm "$PREFIX/share/color-schemes/MateriaDark.colors"
    _rm "$PREFIX/share/color-schemes/MateriaLight.colors"
    _rm "$PREFIX/share/konsole/Materia.colorscheme"
    _rm "$PREFIX/share/konsole/MateriaDark.colorscheme"
    _rm "$PREFIX/share/Kvantum/Materia"
    _rm "$PREFIX/share/Kvantum/MateriaDark"
    _rm "$PREFIX/share/Kvantum/MateriaLight"
    _rm "$PREFIX/share/plasma/desktoptheme/Materia"
    _rm "$PREFIX/share/plasma/desktoptheme/Materia-Color"
    _rm "$PREFIX/share/plasma/look-and-feel/com.github.varlesh.materia"
    _rm "$PREFIX/share/plasma/look-and-feel/com.github.varlesh.materia-dark"
    _rm "$PREFIX/share/plasma/look-and-feel/com.github.varlesh.materia-light"
    _rm "$PREFIX/share/yakuake/skins/materia-dark"
    _rm "$PREFIX/share/yakuake/skins/materia-light"
    _rm "$PREFIX/share/wallpapers/Materia"
    _rm "$PREFIX/share/wallpapers/Materia-Dark"
    _rm "$PREFIX/share/sddm/themes/materia"
    _rm "$PREFIX/share/sddm/themes/materia-dark"
    _rm "$PREFIX/share/sddm/themes/materia-light"
}

_install() {
    _msg "Installing ..."
    sudo cp -R \
        "$temp_dir/$gh_repo-$TAG/aurorae" \
        "$temp_dir/$gh_repo-$TAG/color-schemes" \
        "$temp_dir/$gh_repo-$TAG/konsole" \
        "$temp_dir/$gh_repo-$TAG/Kvantum" \
        "$temp_dir/$gh_repo-$TAG/plasma" \
        "$temp_dir/$gh_repo-$TAG/yakuake" \
        "$temp_dir/$gh_repo-$TAG/wallpapers" \
        "$temp_dir/$gh_repo-$TAG/sddm" \
        "$PREFIX/share"
}

_cleanup() {
    _msg "Clearing cache ..."
    rm -rf "$temp_file" "$temp_dir" \
        ~/.cache/plasma-svgelements-Materia* \
        ~/.cache/plasma_theme_Materia*.kcache
    _msg "Done!"
}

trap _cleanup EXIT HUP INT TERM

temp_file="$(mktemp -u)"
temp_dir="$(mktemp -d)"

if [ "$uninstall" = "false" ]; then
    _download
    _uninstall
    _install
else
    _uninstall
fi
