#!/bin/bash
export WINEPREFIX=~/.wine-flatpak-proton-v61-ge-2
export WINEARCH=win64
export WINEDLLOVERRIDES=mscoree,mshtml=
export LD_LIBRARY_PATH=$(pwd):$LD_LIBRARY_PATH:/app/lib:/app/lib32:/app/$NAME:/app/lib/wine:/app/lib32/wine:/app/lib/i386-linux-gnu:/app/lib/debug/lib/i386-linux-gnu

export ARGV="$@"

export WINEEXE="/app/bin/wine"
export WINETRICKS="/app/bin/winetricks"

if [ "$1" == "winecfg" ] ; then
	/app/bin/winecfg
	
elif [ "$1" == "regedit" ] ; then
	$WINEEXE regedit
	
elif [ -e run.sh ] ; then
	sh run.sh $ARGV
	exit $?
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
