#!/bin/bash
export WINEPREFIX=~/.local/share/proton-ge64-1/default
export WINEARCH=win64
#export WINEDLLOVERRIDES="mscoree,mshtml="
export LD_LIBRARY_PATH=/app/lib:/app/lib32:/app/lib64:/app/lib/i386-linux-gnu:/app/lib/wine:/app/lib64/wine:/app/$NAME:$(pwd)

export ARGV="$@"
export WINEEXE="/app/bin/wine"
export WINETRICKS="/app/bin/winetricks"


# some games need to cd to the dir to work
export base=$(basename $1)
export dire=$(dirname $1)

#echo $base >> ~/Documents/debug.txt
#echo $dire >> ~/Documents/debug.txt
# Create kill shortcut for convenience
mkdir -p ~/.local/share/applications/proton-ge64-1/
echo '
[Desktop Entry]
Exec=flatpak kill org.winehq.proton-ge64-1
Name=Proton-GE-6.4-1 kill (6.4)
Type=Application
Categories=Application;;
Icon=org.winehq.proton-ge64-1-kill
Keywords=flatpak; proton; wine; kill;
' > ~/.local/share/applications/proton-ge64-1/killall_proton-ge64-1.desktop

# if no argument passed then show a dialog with choices
if [ $# -eq 0 ];  then
   echo "No arguments supplied; use --help"
   exit 0
   
# For commandline
elif   [ "$1" == "winecfg" ] ; then
	/app/bin/winecfg
	
elif [ "$1" == "regedit" ] ; then
	$WINEEXE regedit

elif [ "$1" == "winetricks" ] ; then
	ARGV=$(echo $ARGV|sed 's/winetricks//g')
	$WINETRICKS $ARGV
	
elif [ "$1" == "bash" ] ; then
	bash 

elif [ "$1" == "explorer" ]; then
     echo "launching explorer++"
     $WINEEXE /app/explorer++/Explorer++.exe
	 
elif [ "$1" == "--help" ] || [ "$1" == "help" ]; then
    echo "proton-ge64-1 - run wine applicatins/games"
	echo " "
	echo "flatpak run org.winehq.proton-ge64-1 <argument>"
	echo " "
	echo "Arguments can be:"
	echo "bash      : open proton-ge64-1 sandbox in shell"
	echo "explorer  : runs explorer++"
	echo "winetricks: runs winetricks gui, can pass arguments to winetricks"
	echo "regedit   : run registry editor"
	echo "winecfg   : run wine configuration utility"
	echo "help      : this text message"
else
#	$WINEEXE "$EXE" $@
     cd "$dire" 2>/dev/null ;#go to the exe directory then run
     #echo $PWD - pwd >> ~/Documents/debug.txt
     #echo now at $dire >> ~/Documents/debug.txt

	$WINEEXE "$ARGV"
	exit $?
fi
