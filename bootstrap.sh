#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	
    # copy content of this dir to home folder
    echo "copying"
    rsync --exclude ".git/" \
        --exclude "bootstrap.sh" \
	--exclude "*.md" \
	--exclude "all.sh" \
	--exclude "LICENSE" \
	-avh --no-perms . ~;

    #source ~/.config/fish/config.fish
   
    echo "syncing doom"
    ~/.emacs.d/bin/doom -d sync

    echo "kill emacs daemon"
    #emacsclient -e 'doom/reload'
    emacsclient -e '(kill-emacs)'
    
    echo "re-open emacs daemon"
    emacs --daemon
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
