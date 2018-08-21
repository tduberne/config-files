.PHONY: all  ${HOME}/.bashrc ${HOME}/.vimrc ${HOME}/.inputrc ${HOME}/.aliases ${HOME}/.xmonad/xmonad.hs

DATE=$(shell date +'%y.%m.%d_%H:%M:%S_')
RULE="if [ -L $@ ]; then rm $@; fi; if [ -e $@ ]; then mv $@ backups/${DATE}$(@F); fi; ln -s $< $@"

all: ${HOME}/.bashrc ${HOME}/.vimrc ${HOME}/.inputrc ${HOME}/.aliases ${HOME}/.xmonad/xmonad.hs

${HOME}/.bashrc: ${PWD}/shell/bashrc
	eval ${RULE}

${HOME}/.inputrc: ${PWD}/shell/inputrc
	eval ${RULE}

${HOME}/.aliases: ${PWD}/shell/aliases
	eval ${RULE}

${HOME}/.vimrc: ${PWD}/vim/vimrc
	eval ${RULE}

${HOME}/.xmonad/xmonad.hs: ${PWD}/xmonad/xmonad.hs
	eval ${RULE}
