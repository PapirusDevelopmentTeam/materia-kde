<p align="center">
  <img src="https://raw.githubusercontent.com/PapirusDevelopmentTeam/materia-kde/master/preview.png" alt="Preview Materia KDE"/>
</p>
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

**NOTE:** If you maintainer and want be in the list please create an issue or send a pull request.

## Recommendations

- For better looking please use this pack with [Kvantum engine](https://github.com/tsujan/Kvantum/tree/master/Kvantum).

  Run `kvantummanager` to choose and apply **Materia's** theme.

- Install [Papirus icon theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) for a more consistent and beautiful experience.

- On systemsettings set **Noto Sans** font for title, menu and toolbar

- For better looking use toolbar icons without text with 22px size (for Papirus themes)

- For Materia Blur enable translucency and blur effects on KDE sytemsettings. Set value 5 for noise and blur strengths on blur effect settings. 

- Recommend software for better looking with Materia Blur: Dolphin, Ark, Kate, Okular, LXImage-Qt, Falkon, Kopete, KGet, KTorrent, QMPlay2, Clementine Qt5, Octopi, Konsole, Yakuake

## Known issues

- Old version qBittorrent (~3.3.1) not used 22px icon size on toolbar (icons will be blurred, update to fresh version for solve this)

- On some propietary video drivers Aurorae have wrong rendering by default with Adapta theme. See more info [here](https://github.com/PapirusDevelopmentTeam/adapta-kde/issues/21)

- On Materia Blur with enabled blur effect possible some bugs with decoration shadows on aurorae and yakuake skin. [KDE bug](https://bugs.kde.org/show_bug.cgi?id=395725) 



## Donate

If you like my project, you can donate at:

<span class="paypal"><a href="https://www.paypal.me/varlesh" title="Donate to this project using Paypal"><img src="https://www.paypalobjects.com/webstatic/mktg/Logo/pp-logo-100px.png" alt="PayPal donate button" /></a></span>

## License

GNU GPL v3
