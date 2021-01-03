<img src="https://raw.githubusercontent.com/PapirusDevelopmentTeam/materia-kde/master/logo.png" alt="materia-kde-logo" align="right" />

Materia KDE - This is a port of the popular [GTK theme Materia](https://github.com/nana-4/materia-theme) for Plasma 5 desktop with a few additions and extras.

In this repository you'll find:

- Aurorae Theme
- Konsole Color Schemes
- Kvantum Themes
- Plasma Color Schemes
- Plasma Desktop Theme
- Plasma Look-and-Feel Settings
- Yakuake Skins

## Installation

### Ubuntu and derivatives

You can install materia-kde from our official [PPA](https://launchpad.net/~papirus/+archive/ubuntu/papirus):

```
sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt-get install --install-recommends materia-kde
```

or download .deb packages from [here](https://launchpad.net/~papirus/+archive/ubuntu/papirus/+packages?field.name_filter=materia-kde).

### Materia KDE Installer

Use the script to install the latest version directly from this repo (independently on your distro):

#### Install

```
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/materia-kde/master/install.sh | sh
```

#### Uninstall

```
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/materia-kde/master/install.sh | uninstall=true sh
```

### Third-party packages

Packages in this section are not part of the official repositories. If you have a trouble or a question please contact with package maintainer.

| **Distro** | **Maintainer** | **Package** |
|:-----------|:---------------|:------------|
| Arch Linux | Bruno Pagani | `sudo pacman -S materia-kde kvantum-theme-materia` <sup>[[link](https://www.archlinux.org/packages/community/any/materia-kde/)]</sup> |
| Arch Linux | Josip Ponjavic | [materia-kde-git](https://aur.archlinux.org/packages/materia-kde-git) <sup>AUR</sup> |
| openSUSE   | Konstantin Voinov | [materia-kde](https://software.opensuse.org/download.html?project=home:kill_it&package=materia-kde) <sup>OBS [[link](https://build.opensuse.org/package/show/home:kill_it/materia-kde)]</sub> |
| Fedora     | Robert-André Mauchin | [materia-kde](https://src.fedoraproject.org/rpms/materia-kde) |
| Debian 10+ | Debian Desktop Themes Team | [materia-kde](https://tracker.debian.org/pkg/materia-kde) |

**NOTE:** If you maintainer and want be in the list please create an issue or send a pull request.

## Recommendations

- For better looking please use this pack with [Kvantum engine](https://github.com/tsujan/Kvantum/tree/master/Kvantum).

  Run `kvantummanager` to choose and apply **Materia's** theme.

- Install [Papirus icon theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) for a more consistent and beautiful experience.

- Install widgets [Minimal Menu](https://www.opendesktop.org/p/1275285/) and [Digital Clock WL](https://www.opendesktop.org/p/1311422/)

- Set icons view for systemsettings

- Set 16px icon size on Toolbar & Main Toolbar

## Hacks for small screen resolution

- Install widgets [Active Window Control](https://www.opendesktop.org/p/998910/) & [Application Menu](https://cgit.kde.org/plasma-workspace.git/tree/applets/appmenu) and move to panel
- Disable window buttons & titlebar on decoration:

open rc-file on aurorae theme and set:
```
ButtonHeight=0
ButtonWidth=0
TitleHeight=0
TitleEdgeTop=0
```
- Use [GTK3-noCSD](https://github.com/PCMan/gtk3-nocsd) script 

## Known issues

- On NVIDIA propietary video driver Aurorae have wrong rendering by default with Materia theme. For fix that use this config on **~/.Xresources**:

```
Xft.dpi:       96
Xft.antialias: true
Xft.hinting:   true
Xft.autohint:  false
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault
Xft.rgba:      rgb 
```

## BlackList apps
More newest Qt/KDE apps now use QML/Kirigami - this style NOT SUPPORT THEMING on ANY engine, more elements HARDCODED. Please not open issue about that. We can't doing anything!!!
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
- Some modules `systemsettings5` & `kcm`
- to be continued...

## Donate

If you like my project, you can donate at:

<span class="paypal"><a href="https://www.paypal.me/varlesh" title="Donate to this project using Paypal"><img src="https://www.paypalobjects.com/webstatic/mktg/Logo/pp-logo-100px.png" alt="PayPal donate button" /></a></span>

## License

GNU GPL v3
