#!/bin/bash
export WINEPREFIX=~/.wine-x86_64
export WINEARCH=win64
#export WINEDLLOVERRIDES=mscoree=d,mshtml=
export LD_LIBRARY_PATH=$(pwd):$LD_LIBRARY_PATH:/app/lib:/app/lib32:/app/$NAME:/app/lib/wine:/app/lib32/wine:/app/lib/i386-linux-gnu:/app/lib/debug/lib/i386-linux-gnu

export ARGV="$@"
export WINEEXE="/app/bin/wine"
export WINETRICKS="/app/bin/winetricks"


# some games need to cd to the dir to work
export base=$(basename $1)
export dire=$(dirname $1)

#echo $base >> ~/Documents/debug.txt
#echo $dire >> ~/Documents/debug.txt
# Create kill shortcut for convenience
mkdir -p ~/.local/share/applications/wine-x86_64/
echo '
[Desktop Entry]
Exec=flatpak kill org.winehq.wine-x86_64 
Name=Killall wine-x86_64 instances
Type=Application
Categories=Application;;
Icon=org.winehq.wine-x86_64
Keywords=flatpak; wine; kill;
' > ~/.local/share/applications/wine-x86_64/killall_proton.desktop

# if no argument passed then launch winefile (from wine.desktop)
if [ $# -eq 0 ];  then
    echo "No arguments supplied"
    echo "launching explorer++"
    /app/bin/wine /app/explorer++/Explorer++.exe

elif   [ "$1" == "winecfg" ] ; then
	/app/bin/winecfg
	
elif [ "$1" == "regedit" ] ; then
	$WINEEXE regedit

elif [ "$1" == "winetricks" ] ; then
	ARGV=$(echo $ARGV|sed 's/winetricks//g')
	$WINETRICKS $ARGV
	
elif [ "$1" == "bash" ] ; then
	bash 
	
else
#	$WINEEXE "$EXE" $@
        cd $dire 2>/dev/null;#go to the exe directory then run
        #echo $PWD - pwd >> ~/Documents/debug.txt
        #echo now at $dire >> ~/Documents/debug.txt

	$WINEEXE "$ARGV"
	exit $?
fi
