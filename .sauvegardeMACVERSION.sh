#!/bin/bash

delete_olderfolder()
{
	filenumber=$(find /Users/briffard/sauvegarde -maxdepth 1 -type d | grep -v .git | wc -l)
	if [ $filenumber > 2 ]; then
		olderfolder=$(stat -f "%Sm %N" /Users/briffard/sauvegarde/* | sort -n | grep -v .git | awk '{prnit $6}' | sed -n '1p')
#find /home/chopper/sauvegarde -maxdepth 1 -type d -exec stat --format="%y %b %n" {} \; | grep -v .git | sort | awk '{print$5}' | sed -n '1p'
		rm -rf $olderfolder
	fi
}

backup_local()
{
	if [ ! -e "/Users/briffard//sauvegarde" ]; then
		git clone git@github.com:B9R9/backup /Users/briffard/sauvegarde
		touch /Users/briffard/sauvegarde/backup.log
	fi
	for line in $(find /Users/briffard/Desktop/* -type f -mmin -60 |  grep -v .git)
	do
		echo $line
		subfolder="Backuptime:$(date +%H:%M:%S)"
		folder=$(date +%d%b%g)
		if [ ! -e /Users/briffard/sauvegarde/"$folder" ]; then
			mkdir /Users/briffard/sauvegarde/"$folder"
		fi
		if [ ! -e /Users/briffard/sauvegarde/"$folder"/"$subfolder" ]; then
			mkdir /Users/briffard/sauvegarde/"$folder"/"$subfolder"
		fi
		cp $line /Users/briffard/sauvegarde/"$folder"/"$subfolder"
		if [ $( grep -L "$subfolder" /Users/briffard/sauvegarde/backup.log) ]; then
			date >> /Users/briffard/sauvegarde/backup.log
			echo -e "Path des fichiers sauvegardes:\n" >> /Users/briffard/sauvegarde/backup.log
		fi
		echo -e "\t - $line" >> /Users/briffard/sauvegarde/backup.log
	done
	echo -e "\n================================================\n">>/Users/briffard/sauvegarde/backup.log
}

backup_git()
{
	cd /Users/briffard/sauvegarde/
	git add .
	git commit -m "BACK UP: $subfolder"
	git push
}

option()
{
	echo "Usage: ./sauvegarde.sh [option]"
	echo "Option available:"
	echo -e "\tlocal:   save everyfile in the workspace directory to another directory."
	echo -e "\tdistant: save file to github repository."
	echo -e "\thelp:    show option.For more setup, please consult setup option."
	echo -e "\tsetup:   help to configure the programm."
}

if [ $1 = 'local' ]; then
	backup_local
	delete_olderfolder
elif [ $1 = 'distant' ]; then
	backup_local
	delete_olderfolder
	cd /home/chopper/sauvegarde/
	backup_git
elif [ $1 = 'help' ]; then
	option 
elif [ $1 = 'setup' ]; then
	echo " Ecrire une versionman de shell"
else
	option
fi