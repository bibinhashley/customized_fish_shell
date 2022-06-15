#!/bin/sh

set -e

printf -- "\033[1mWelcome to installation of customized fish shell.\033[0m\n\n"
printf -- "\033[1m------------------------------------------------ \n\n"
sleep 2

while true; do
	read -p "Do you want to update system? (yes/no):" update
	case $update in
	[Yy]*)
		printf -- "Doing a system update. \n\n"
		sudo pacman --noconfirm -Syyu
		break
		;;

	[Nn]*)
		break
		;;
	*)
		echo "Please answer yes or no."
		;;
	esac
done

printf -- "\n"
printf -- "\033[32m System Update success.\033[0m\n\n"
printf -- "Checking if  fish shell is installed.\n\n"

if ! command -v fish &>/dev/null; then
	printf -- "fish is not installed, installing now. \n\n"
	sudo pacman -S fish
	printf -- "\033[32m \033[1mFish installation success.\033[0m\n\n"
else
	printf -- "\033[32m \033[1mFish is already installed.\033[0m\n\n"
fi

printf -- "\033[1mInstalling dependencies.\n\n"

sudo pacman -S --noconfirm --needed mcfly exa neofetch starship
printf -- "\n"
printf -- "\033[32m \033[1mInstalling dependencies success.\033[0m\n\n"

if [ -e ~/.config/fish/config.fish ]; then
	printf -- "\033[1mConfig file exists, taking backup. \033[0m\n\n"
	mv ~/.config/fish/config.fish ~/.config/fish/config.fish.bak
else
	mkdir -p ~/.config/fish/conf.d
fi

printf -- "\033[1mCopying fish config file. \033[0m\n\n"

cp ./config_file/config.fish ~/.config/fish/

sleep 2

printf -- "\033[1mCopying starship config file. \033[0m\n\n"

cp ./config_file/starship.toml ~/.config/

printf -- "\033[1mCopying mcfly config file. \033[0m\n\n"
cp ./config_file/mcfly.fish ~/.config/fish/conf.d/

printf -- "\033[32m \033[1mCopying all config files success. \033[0m\n\n"

# printf -- "Changing shell to fish. \n\n"

# chsh -s $(which fish)

emulator_name=$(basename '/'$(ps -o cmd -f -p $(cat /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed 's/ .*$//'))
if [ ${emualator_name}=="konsole" ]; then
	printf -- "\033[91m Detected you are using Konsole, you might have to change shell it in settings. \033[0m\n\n"
fi
printf -- "\033[32m \033[1mInstallation has successfully done.\033[0m\n\n"

exit 0
