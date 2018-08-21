.PHONY: all

DATE=$(shell date +'%y.%m.%d_%H:%M:%S_')
RULE="if [ -e $@ ]; then mv $@ backups/${DATE}$(@F); fi; ln -s $< $@"

all: ${HOME}/.bashrc ${HOME}/.vimrc

${HOME}/.bashrc: shell/bashrc
	eval ${RULE}

${HOME}/.inputrc: shell/inputrc
	eval ${RULE}

${HOME}/.aliases: shell/aliases
	eval ${RULE}

${HOME}/.vimrc: vim/vimrc
	eval ${RULE}

${HOME}/.xmonad/xmonad.hs: xmonad/xmonad.hs
	eval ${RULE}
