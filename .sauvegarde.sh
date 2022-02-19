#!/bin/bash

delete_olderfolder()
{
	filenumber=$(find /home/chopper/sauvegarde -maxdepth 1 -type d | grep -v .git | wc -l)
	if [ $filenumber > 2 ]; then
		olderfolder=$(find /home/chopper/sauvegarde -maxdepth 1 -type d -exec stat --format="%y %b %n" {} \; | grep -v .git | sort | awk '{print$5}' | sed -n '1p')
		rm -rf $olderfolder
	fi
}

backup_local()
{
	if [ ! -e "/home/chopper/sauvegarde" ]; then
		git clone git@github.com:B9R9/backup /home/chopper/sauvegarde
		touch ./sauvegarde/backup.log
	fi
	for line in $(find /home/chopper/workspace -type f -mmin 60 |  grep -v .git)
	do
		subfolder=$(date)
		folder=$(date +%d%b%g)
		if [ ! -e /home/chopper/sauvegarde/"$folder" ]; then
			mkdir /home/chopper/sauvegarde/"$folder"
		fi
		if [ ! -e /home/chopper/sauvegarde/"$folder"/"$subfolder" ]; then
			mkdir /home/chopper/sauvegarde/"$folder"/"$subfolder"
		fi
		cp $line /home/chopper/sauvegarde/"$folder"/"$subfolder"
		if [ $( grep -L "$subfolder" /home/chopper/sauvegarde/savedfilelist.txt) ]; then
			date >> /home/chopper/sauvegarde/backup.log
			echo -e "Path des fichiers sauvegardes:\n" >> /home/chopper/sauvegarde/backup.log
		fi
		echo -e "\t - $line" >> /home/chopper/sauvegarde/backup.log
	done
	echo -e
	"\n================================================\n">>/home/chopper/sauvegarde/backup.log
}

backup_git()
{
	cd /home/chopper/sauvegarde/
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