#!/bin/bash
export WINEPREFIX=~/.wine-wine_x64
export WINEARCH=win64
export WINEDLLOVERRIDES=mscoree,mshtml=
export LD_LIBRARY_PATH=$(pwd):$LD_LIBRARY_PATH:/app/lib:/app/lib32:/app/$NAME:/app/lib/wine:/app/lib32/wine:/app/lib/i386-linux-gnu:/app/lib/debug/lib/i386-linux-gnu

export ARGV="$@"

export WINEEXE="/app/bin/wine64"
export WINETRICKS="/app/bin/winetricks"

# if no argument passed then launch winecfg (from wine.desktop)
if [ $# -eq 0 ];  then
    echo "No arguments supplied"
    echo "launching explorer"
    /app/bin/winefile
    
elif [ "$1" == "winecfg" ] ; then
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
	$WINEEXE "$ARGV"
	exit $?
fi
