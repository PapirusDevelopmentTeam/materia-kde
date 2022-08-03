<img src="https://raw.githubusercontent.com/PapirusDevelopmentTeam/materia-kde/master/logo.png" alt="materia-kde-logo" align="right" />

# Materia KDE

This is a port of the popular [GTK theme Materia](https://github.com/nana-4/materia-theme) for the Plasma 5 desktop with a few additions and extras.

In this repository you'll find:
- Aurorae window decoration themes
- Konsole color schemes
- Kvantum themes
- Plasma color schemes
- Plasma Desktop themes
- Plasma Look-and-Feel settings
- Yakuake skins
- SDDM themes
- Wallpapers

## Installation

### Ubuntu and derivatives

You can install materia-kde from our official [PPA](https://launchpad.net/~papirus/+archive/ubuntu/papirus):

```
sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt-get install --install-recommends materia-kde
```

or download .deb packages from [here](https://launchpad.net/~papirus/+archive/ubuntu/papirus/+packages?field.name_filter=materia-kde).

### Materia KDE installer

#### Install

Use this command to install the latest version directly from this repo (independently of your distro):

```
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/materia-kde/master/install.sh | sh
```

#### Uninstall

```
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/materia-kde/master/install.sh | uninstall=true sh
```

### Third-party packages

Packages in this section are not part of the official repositories. If you have any questions or concerns about any of these packages, please contact the package maintainer.

| **Distro** | **Maintainer** | **Package** |
|:-----------|:---------------|:------------|
| Arch Linux | Bruno Pagani | `sudo pacman -S materia-kde kvantum-theme-materia` <sup>[[link](https://www.archlinux.org/packages/community/any/materia-kde/)]</sup> |
| Arch Linux | Josip Ponjavic | [materia-kde-git](https://aur.archlinux.org/packages/materia-kde-git) <sup>AUR</sup> |
| openSUSE   | Konstantin Voinov | [materia-kde](https://software.opensuse.org/download.html?project=home:kill_it&package=materia-kde) <sup>OBS [[link](https://build.opensuse.org/package/show/home:kill_it/materia-kde)]</sub> |
| Fedora     | Robert-André Mauchin | `sudo dnf install materia-kde` <sup>[[src](https://src.fedoraproject.org/rpms/materia-kde)]</sup> |
| Debian 10+ | Debian Desktop Themes Team | [materia-kde](https://tracker.debian.org/pkg/materia-kde) |

**NOTE:** If you are a maintainer and want your package to be in this list, please feel free to create an issue or pull request.

## Recommendations

- For a more consistent look on Qt and KDE apps, please use this theme with the [Kvantum engine](https://github.com/tsujan/Kvantum). \
  Run `kvantummanager`, then choose and apply the **Materia** theme.
- Install [Papirus icon theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) for a more consistent and beautiful experience.
- Install and use these widgets: [Minimal Menu](https://www.opendesktop.org/p/1275285/) and [Digital Clock WL](https://www.opendesktop.org/p/1311422/)
- Change the System Settings view to **Icons View**
- Set the icon size for Toolbar and Main Toolbar to **16px**
- Set the border size to **No Borders** in Window Decoration settings

### Hacks for smaller screen resolutions

- Install the [Active Window Control](https://www.opendesktop.org/p/998910/) and [Application Menu](https://cgit.kde.org/plasma-workspace.git/tree/applets/appmenu) widgets, and move them to a panel. \
  (**NOTE:** Application Menu is already included with recent versions of KDE Plasma, so there is no need to install it manually.)
- Disable window buttons and titlebar on window decorations:
  - Open the theme's rc file (**Materiarc**, **Materia-Darkrc**, or **Materia-Lightrc**) on the Aurorae themes folder (this is usually located in **~/.local/share/aurorae/themes** or **/usr/share/aurorae/themes**) and change the following lines:
    ```
    ButtonHeight=0
    ButtonWidth=0
    TitleHeight=0
    TitleEdgeTop=0
    ```
  - To hide window buttons on GTK 3 apps, use the [GTK3-noCSD](https://github.com/PCMan/gtk3-nocsd) script

## Known issues

### Aurorae rendering bugs with NVIDIA graphics

On systems using the proprietary NVIDIA video driver, Aurorae window decorations [do not render properly](https://bugs.kde.org/show_bug.cgi?id=384457) by default with all themes.

| **Wrong rendering** | **Correct rendering** |
|:--------------------|:----------------------|
| ![wrong-rendering](https://i.imgur.com/rS5OgPf.png) | ![right-rendering](https://i.imgur.com/5OKjULE.png) |

To fix that, use this config on **~/.Xresources**:
```
Xft.dpi:       96
Xft.antialias: true
Xft.hinting:   true
Xft.autohint:  false
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault
Xft.rgba:      rgb
```
Restart your PC to apply these changes.

### Inconsistent styles in QML/Kirigami apps

Recent Qt and KDE apps now use QML or Kirigami — these do *NOT* fully support theming on *any* engine because more elements are *hardcoded*. Please do not submit new issues regarding such apps; we can't do anything to fix them.

Affects apps include, but are not limited to:
- Muon Discover
- Kirigami Gallery
- Ikona
- Alligator
- Kaidan
- Elisa
- KDE Itinerary
- KTrip
- Kirogi
- VVave (ex Babe)
- Keysmith
- Calindori
- KDE Connect SMS Module
- Some `systemsettings5` and `kcm` modules
- and more...

## More Materia themes

- [Materia skin for VLC](https://github.com/PapirusDevelopmentTeam/materia-vlc)
- [Telegram theme](https://t.me/addtheme/MateriaDarkUpdated)
- [Pegasus Frontend theme](https://github.com/varlesh/pegasus-materia-dark)

## Donate


## License

Copyright © 2018–2021 [Alexey Varfolomeev](https://github.com/varlesh) and contributors.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
