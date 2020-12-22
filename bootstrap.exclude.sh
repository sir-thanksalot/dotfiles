#!/usr/bin/env bash

PROMPT='[bootstrap]'

init () {
	# ref: https://askubuntu.com/a/30157/8698
	if ! [ $(id -u) = 0 ]; then
		echo "I am not root! :("
		exit 1
	fi

	if [ $SUDO_USER ]; then
		real_user=$SUDO_USER
	else
		real_user=$(whoami)
	fi
	real_home=$( getent passwd $real_user | cut -d: -f6 )

	# ref: https://stackoverflow.com/a/4774063
	scriptpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

	PATH_TO_PLAYGROUND="$real_home/playground"
	PATH_TO_PROJECTS="$real_home/projects"
	PATH_TO_USER_BIN="$real_home/bin"
	PATH_TO_REPLACED_DOTFILES="$real_home/.replaced_dotfiles"
}

create_dirs() {
	echo "$PROMPT Create 'projects' and 'playground' directorys? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		sudo -u $real_user mkdir -p "$PATH_TO_PROJECTS"
		sudo -u $real_user mkdir -p "$PATH_TO_PLAYGROUND"
	fi

	echo "$PROMPT Create 'bin' directory? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		sudo -u $real_user mkdir -p "$PATH_TO_USER_BIN"
	fi

	echo "$PROMPT Creating $PATH_TO_REPLACED_DOTFILES"
	sudo -u $real_user mkdir -p "$PATH_TO_REPLACED_DOTFILES"
}

link () {
	echo "$PROMPT I want to symlink the files in this repo to the home directory."
	echo "$PROMPT All files that already exist there will be moved to $PATH_TO_REPLACED_DOTFILES"
	echo "$PROMPT Okay? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		for file in $( ls -A $scriptpath | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md|\.vscode' ) ; do
			[ -f "$real_home/$file" ] && mv "$real_home/$file" "$PATH_TO_REPLACED_DOTFILES" 
			sudo -u $real_user ln -sv "$scriptpath/$file" "$real_home"
		done
		echo "$PROMPT Symlinking is done! :)"
	else
		echo "$PROMPT Symlinking cancelled :("
		return 1
	fi
}

install_tools () {
	if [ $( echo "$OSTYPE" | grep 'linux-gnu' ) ] ; then
		# basic setup
		# source install functions
		source "$scriptpath/installs.exclude.sh"
		echo "$PROMPT Now I want to install some useful stuff (for now only with apt on debian, sorry..).?"
		echo "$PROMPT First some basics, okay? (y/n)"
		read resp
		if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
			\. "$scriptpath/install_basics.exclude.sh"
		fi
	else
		echo "$PROMPT I'm not on Linux (Debian), so I can't install... :("
	fi
}

init
create_dirs
link
install_tools

source "$real_home/.bash_profile"