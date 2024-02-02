#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;37m' 
END='\033[0m'
BOLD='\033[1m'
GRAY='\033[2m'
ITALIC='\033[3m'

TYPE=$1
printf "${BOLD}┏━┓┏━┓┏━╸╻ ╻┏┓ ┏━┓╻ ╻${GRAY} ┏━┓╻ ╻${END}\n"
printf "${BOLD}┣━┫┣┳┛┃  ┣━┫┣┻┓┃ ┃┏╋┛${GRAY} ┗━┓┣━┫${END}\n"
printf "${BOLD}╹ ╹╹┗╸┗━╸╹ ╹┗━┛┗━┛╹ ╹${GRAY}╹┗━┛╹ ╹${END}\n"

printf "${ITALIC} Simple script for install openbox with themes in Arch Linux ${END}\n\n"

function is_pkg_installed() {
	pkg=$1
	if pacman -Qs $pkg > /dev/null; then
		printf "${ITALIC}${GREY}${pkg} is installed${END}\n"
	else
		printf "${BLUE}${ITALIC}${pkg} installing...${END}\n"
		sudo pacman -S $pkg --noconfirm
	fi
}

function openbox {
	printf "${BLUE}${ITALIC}Install base utils${END}\n"
	sudo pacman -S unzip git wget feh picom tint setxkbmap micro vim neovim zathura nitrogen terminator nemo gnome-terminal --noconfirm
	printf "${BLUE}${ITALIC}Install full functional openbox ${END}\n"
	sudo pacman -S openbox obconf lxappearance-gtk3 menumaker --noconfirm
	printf "${BLUE}${ITALIC}${GREY}Check installed base X11 packages...${END}\n"

	is_pkg_installed "xorg-xinit"
	is_pkg_installed "xorg-server"
	is_pkg_installed "xclip"
	is_pkg_installed "xorg-apps"
	is_pkg_installed "mesa"

	printf "${YELLOW}Post-installion...${END}\n"
	mkdir -p ~/.config/openbox
	cp /etc/xdg/openbox/* -r ~/.config/openbox
	cp configs/openbox/autostart -r ~/.config/openbox/autostart
	cp configs/.xxkbrc -r ~/.xxkbrc

	printf "${YELLOW}${ITALIC}Install AUR programs...${END}\n"
	git clone https://aur.archlinux.org/obmenu
	cd obmenu
	makepkg -sric
	cd ..
}

function design {
	mkdir -p design
	printf "${PURPLE}${ITALIC}Install wallpapers${END}\n"
	sudo pacman -S elementary-wallpapers --noconfirm
	printf "${PURPLE}${ITALIC}Install fonts${END}\n"
	sudo pacman -S ttf-dejavu ttf-ubuntu-nerd ttf-jetbrains-mono-nerd ttf-iosevka-nerd --noconfirm
	printf "${PURPLE}${ITALIC}Install icons${END}\n"
	sudo pacman -S papirus-icon-theme oxygen-icons obsidian-icon-theme gnome-icon-theme-extras --noconfirm
	printf "${PURPLE}${ITALIC}Install themes${END}\n"
	sudo pacman -S arc-gtk-theme adapta-gtk-theme gnome-themes-extra --noconfirm
	git clone https://github.com/reorr/my-theme-collection.git design/themes-reoor
	git clone https://github.com/zakuradev/openbox-themes design/openbox-theme-zakuradev
	git clone https://github.com/Dr-Noob/Arc-Dark-OSX design/ArcDarkOSX
	git clone https://github.com/logico/typewriter-gtk design/typewriter
	git clone https://github.com/addy-dclxvi/tint2-theme-collections design/tint2-themes
	git clone https://github.com/ilnanny/XThemes design/xthemes-ilnanny
	git clone https://github.com/YurinDoctrine/.config.git design/themes-gnomelike
	git clone https://github.com/jr20xx/Mint-O-Themes design/mint-openbox

	printf "${GREY}More openbox themes: www.box-look.org/browse?cat=140${END}"
}

if [[ "$TYPE" = "full" ]]; then
	printf "${CYAN}${BOLD}Start full installion...${END}\n"
	sudo pacman -Syu
	printf "${BLUE}Install openbox with utils...\n${END}"
	openbox
	printf "${PURPLE}Install themes, icons, fonts, etc...\n${END}"
	design
	printf "${GREEN}End installion! Configure your openbox!${END}"
elif [[ "$TYPE" = "openbox" ]]; then
	printf "${BLUE}${BOLD}Start full installion...${END}\n"
	openbox
	printf "${GREEN}End installion! Configure your openbox!${END}"
elif [[ "$TYPE" = "design" ]]; then
	printf "${PURLE}${BOLD}Start full installion...${END}\n"
	design
	printf "${GREEN}End installion! Configure your openbox!${END}"
else
	printf "${RED}Invalid flag: ${TYPE}${END}\n"
	printf "Use: ./archbox.sh <full/openbox/design>\n"
	printf "full - openbox with themes, icons, etc\n"
	printf "openbox - only openbox with basic utils\n"
	printf "design - only design without openbox\n"
	exit 0
fi
