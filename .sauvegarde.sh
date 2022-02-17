#!/bin/bash

backup_local()
{
	for line in $(find /home/chopper/workspace -type f -mtime -1 |  grep -v .git)
	do
		if [ ! -e "/home/chopper/sauvegarde" ]; then
			git clone git@github.com:B9R9/backup /home/chopper/sauvegarde
			touch ./sauvegarde/savedfilelist.txt
		fi
		jour=$(date)
		if [ ! -e ./sauvegarde/"$jour" ]; then
			mkdir ./sauvegarde/"$jour"
		fi
		cp $line ./sauvegarde/"$jour"
		if [ $( grep -L "$jour" ./sauvegarde/savedfilelist.txt) ]; then
			date >> ./sauvegarde/savedfilelist.txt
			echo -e "Path des fichiers sauvegardes:\n" >> ./sauvegarde/savedfilelist.txt
		fi
		echo -e "\t - $line" >> ./sauvegarde/savedfilelist.txt
	done
	echo -e "\n================================================\n" >>./sauvegarde/savedfilelist.txt
}

backup_git()
{
	cd /home/chopper/sauvegarde/
	git add .
	git commit -m "back up $jour"
	git push
}

option()
{
	echo "Usage: ./  sauvegarde.sh [option]"
	echo "Option available:"
	echo -e "\tlocal:   save everyfile in the workspace directory to another directory."
	echo -e "\tdistant: save file to github repository."
	echo -e "\thelp:    show option.For more setup, please consult setup option."
	echo -e "\tsetup:   help to configure the programm."
}

if [ $1 = 'local' ]; then
	backup_local
elif [ $1 = 'distant' ]; then
	backup_local
	cd /home/chopper/sauvegarde/
	backup_git
elif [ $1 = 'help' ]; then
	option 
elif [ $1 = 'setup' ]; then
	echo " By default the programm lookinf for file who has been modified the
day in a specifique directory. This can be change line 5 of the programm by
changing the path of the directory and the option mtime. If you want looking
for file modifef the last 5 minutes, changed -mtime by mmin following by the
number -n(number of minutes). Every path can be can for your convenance."
else
	option
fi