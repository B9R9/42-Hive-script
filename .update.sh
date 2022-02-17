# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    .update.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: briffard <briffard@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/01/31 15:36:26 by briffard          #+#    #+#              #
#    Updated: 2022/02/15 13:31:36 by briffard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#bin/bash

update_system()
{
	sudo apt update
	apt list --upgrade
	sudo apt full-upgrade
	sudo apt autoremove
	sudo apt autoclean
}

update_norminette()
{
	python3 -m pip install --upgarde pip
	python3 -m pip install --upgrade norminette
}

update_vim()
{
	rm -rf /home/chopper/.vim
	git clone git@github.com:B9R9/My_vim_config.git /home/chopper/.vim
	cp /home/chopper/.vim/.vimrc /home/chopper/
}

update_git()
{
	git fetch
	git pull
}

if [ $1 = 'system' ]; then
	update_system
elif [ $1 = 'norminette' ]; then
	update_norminette
elif [ $1 = 'vim' ]; then
	update_vim
elif [ $1 = 'repo' ]; then
	if [ -e "/home/chopper/workspace/B9R9-$2" ]; then
		cd /home/chopper/workspace/B9R9-$2/
		update_git
	else
		git clone git@github.com:B9R9/42-Hive-$2.git /home/chopper/workspace/B9R9-$2
		grep "${2}" /home/chopper/.oh-my-zsh/custom/example.zsh
		if [ $( grep -L "${2}" /home/chopper/.oh-my-zsh/custom/example.zsh) ]; then
			echo "$2repo=~/workspace/B9R9-$2" >>/home/chopper/.oh-my-zsh/custom/example.zsh
			source /home/chopper/.oh-my-zsh/custom/example.zsh
		fi
		filenumber=$(ls /home/chopper/workspace/B9R9-$2 | wc -l)
		if [ $filenumber = '0' ]; then
			echo "briffard" >> /home/chopper/workspace/B9R9-$2/author
			touch /home/chopper/workspace/B9R9-$2/main.c
			touch /home/chopper/workspace/B9R9-$2/$2.h
			touch /home/chopper/workspace/B9R9-$2/Makefile
			touch /home/chopper/workspace/B9R9-$2/suiviprojet
		fi
	fi
fi

