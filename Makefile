# GNU make is required to run this file. To install on *BSD, run:
#   gmake PREFIX=/usr/local install

PREFIX ?= /usr
IGNORE ?=
THEMES ?= aurorae color-schemes konsole Kvantum plasma yakuake wallpapers sddm

# excludes IGNORE from THEMES list
THEMES := $(filter-out $(IGNORE), $(THEMES))

all:

install:
	mkdir -p $(DESTDIR)$(PREFIX)/share
	cp -R $(THEMES) $(DESTDIR)$(PREFIX)/share

uninstall:
	-rm -rf $(DESTDIR)$(PREFIX)/share/aurorae/themes/Materia
	-rm -rf $(DESTDIR)$(PREFIX)/share/aurorae/themes/Materia-Dark
	-rm -rf $(DESTDIR)$(PREFIX)/share/aurorae/themes/Materia-Light
	-rm -r  $(DESTDIR)$(PREFIX)/share/color-schemes/MateriaDark.colors
	-rm -r  $(DESTDIR)$(PREFIX)/share/color-schemes/MateriaLight.colors
	-rm -r  $(DESTDIR)$(PREFIX)/share/konsole/Materia.colorscheme
	-rm -r  $(DESTDIR)$(PREFIX)/share/konsole/MateriaDark.colorscheme
	-rm -rf $(DESTDIR)$(PREFIX)/share/Kvantum/Materia
	-rm -rf $(DESTDIR)$(PREFIX)/share/Kvantum/MateriaDark
	-rm -rf $(DESTDIR)$(PREFIX)/share/Kvantum/MateriaLight
	-rm -rf $(DESTDIR)$(PREFIX)/share/plasma/desktoptheme/Materia
	-rm -rf $(DESTDIR)$(PREFIX)/share/plasma/desktoptheme/Materia-Color
	-rm -rf $(DESTDIR)$(PREFIX)/share/plasma/look-and-feel/com.github.varlesh.materia
	-rm -rf $(DESTDIR)$(PREFIX)/share/plasma/look-and-feel/com.github.varlesh.materia-dark
	-rm -rf $(DESTDIR)$(PREFIX)/share/plasma/look-and-feel/com.github.varlesh.materia-light
	-rm -rf $(DESTDIR)$(PREFIX)/share/yakuake/skins/materia-dark
	-rm -rf $(DESTDIR)$(PREFIX)/share/yakuake/skins/materia-light
	-rm -rf $(DESTDIR)$(PREFIX)/share/wallpapers/Materia
	-rm -rf $(DESTDIR)$(PREFIX)/share/wallpapers/Materia-Dark
	-rm -rf $(DESTDIR)$(PREFIX)/share/sddm/themes/materia
	-rm -rf $(DESTDIR)$(PREFIX)/share/sddm/themes/materia-dark
	-rm -rf $(DESTDIR)$(PREFIX)/share/sddm/themes/materia-light

_get_version:
	$(eval VERSION := $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

dist: _get_version
	git archive --format=tar.gz -o $(notdir $(CURDIR))-$(VERSION).tar.gz master -- $(THEMES)

release: _get_version
	git tag -f $(VERSION)
	git push origin
	git push origin --tags

undo_release: _get_version
	-git tag -d $(VERSION)
	-git push --delete origin $(VERSION)


.PHONY: all install uninstall _get_version dist release undo_release

# .BEGIN is ignored by GNU make so we can use it as a guard
.BEGIN:
	@head -3 Makefile
	@false
