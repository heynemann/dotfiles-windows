SHELL=/bin/bash
PWD=$(shell pwd)
ZSHPATH=$(shell which zsh)
ZSHINSHELLS=$(shell grep ${ZSHPATH} /etc/shells)

setup: git-setup zsh-setup vim-setup

git-setup:
	@git config --global user.name "Bernardo Heynemann"
	@git config --global user.email heynemann@gmail.com
	@git config --global color.diff auto
	@git config --global color.status auto
	@git config --global color.branch auto
	@git config --global core.editor "vim"

zsh-setup: zsh-brew zsh-set-default zsh-symlinks

zsh-brew:
	@brew install zsh
	@brew install sheldon
	@brew install starship

zsh-set-default:
	@echo "Looking for ZSH in ${ZSHPATH}..."
	@if [ "${ZSHINSHELLS}" == "" ]; then echo "zsh not found in /etc/shells. Including it..."; sudo bash -c "echo \"${ZSHPATH}\" >> /etc/shells"; fi
	@chsh -s ${ZSHPATH}

zsh-symlinks:
	@mkdir -p ~/.config/sheldon
	@rm -f ~/.zsh
	@rm -f ~/.zshrc
	@ln -s ${PWD}/zsh/ ~/.zsh
	@ln -s ${PWD}/zsh/zshrc ~/.zshrc
	@ln -sf ${PWD}/zsh/zsh_history ~/.zsh_history
	@rm -f ~/.config/sheldon/plugins.toml
	@ln -s ${PWD}/zsh/sheldon.toml ~/.config/sheldon/plugins.toml 
	@rm -f ~/.config/starship.toml
	@ln -s ${PWD}/zsh/starship.toml ~/.config/starship.toml
	@rm -f ~/.alias.zsh
	@ln -s ${PWD}/zsh/alias.zsh ~/.alias.zsh

vim-setup: vim-brew vim-symlinks

vim-brew:
	@brew install fzf
	@brew install vim

vim-symlinks:
	@rm -f ~/.vim
	@rm -f ~/.vimrc
	@ln -s ${PWD}/vim/ ~/.vim
	@ln -s ${PWD}/vim/vimrc ~/.vimrc
	@touch ~/.extras.vim