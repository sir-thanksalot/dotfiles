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
	homedir=$( getent passwd $real_user | cut -d: -f6 )

	# ref: https://stackoverflow.com/a/4774063
	scriptpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

	PATH_TO_PLAYGROUND="$homedir/playground"
	PATH_TO_PROJECTS="$homedir/projects"
	PATH_TO_USER_BIN="$homedir/bin"
	PATH_TO_REPLACED_DOTFILES="$homedir/.replaces_dotfiles"
}

create_dirs() {
	echo "$PROMPT Create 'projects' and 'playground' directorys? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		mkdir -p "$PATH_TO_PROJECTS"
		mkdir -p "$PATH_TO_PLAYGROUND"
	fi

	echo "$PROMPT Create 'bin' directory? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		mkdir -p "$PATH_TO_USER_BIN"
	fi

	echo "$PROMPT Creating $PATH_TO_REPLACED_DOTFILES"
	mkdir -p "$PATH_TO_REPLACED_DOTFILES"
}

link () {
	echo "$PROMPT I want to symlink the files in this repo to the home directory."
	echo "$PROMPT All files that already exist there will be moved to $PATH_TO_REPLACED_DOTFILES"
	echo "$PROMPT Okay? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		for file in $( ls -A $scriptpath | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md|\.vscode' ) ; do
			[ -f "$homedir/$file" ] && mv "$homedir/$file" "$PATH_TO_REPLACED_DOTFILES" 
			ln -sv "$scriptpath/$file" "$homedir"
		done
		echo "$PROMPT Symlinking is done! :)"
	else
		echo "$PROMPT Symlinking cancelled :("
		return 1
	fi
}

install_tools () {
	if [ $( echo "$OSTYPE" | grep 'linux-gnu' ) ] ; then
		echo "$PROMPT Now I want to install some useful stuff (for now only with apt on debian, sorry..)"
		echo "$PROMPT So i assume you're fine with that? (y/n)"
		read resp
		if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
			echo "$PROMPT First lets install the basics..."
			sh "$scriptpath/init_installs.exclude.sh"
		else
			echo "$PROMPT Okay, but don't complain later.. "
		fi
	else
		echo "$PROMPT I'm not on Linux (Debian), so I can't install all the cool stuff... :("
	fi
}

init
create_dirs
link
install_tools