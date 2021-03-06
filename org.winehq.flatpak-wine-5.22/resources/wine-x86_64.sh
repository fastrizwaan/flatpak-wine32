#!/bin/bash
export WINEPREFIX=~/.wine-x86_64
export WINEARCH=win64
#export WINEDLLOVERRIDES="mscoree,mshtml="
export LD_LIBRARY_PATH=$(pwd):$LD_LIBRARY_PATH:/app/lib:/app/lib32:/app/$NAME:/app/lib/wine:/app/lib32/wine:/app/lib/i386-linux-gnu:/app/lib/debug/lib/i386-linux-gnu

export ARGV="$@"
export WINEEXE="/app/bin/wine"
export WINETRICKS="/app/bin/winetricks"


# some games need to cd to the dir to work
export base=$(basename "$1")
export dire=$(dirname "$1")

#echo $base >> ~/Documents/debug.txt
#echo $dire >> ~/Documents/debug.txt
# Create kill shortcut for convenience
mkdir -p ~/.local/share/applications/wine-x86_64/
echo '
[Desktop Entry]
Exec=flatpak kill org.winehq.flatpak-wine
Name=flatpak-wine kill (5.22)
Type=Application
Categories=Application;;
Icon=org.winehq.flatpak-wine-kill
Keywords=flatpak; wine; kill;
' > ~/.local/share/applications/wine-x86_64/killall_wine-5.22.desktop

# if no argument passed then show a dialog with choices
if [ $# -eq 0 ];  then
   echo "No arguments supplied"
   echo "launching explorer++"
   
   # for GUI Dialog
   choice=$(zenity --title "flatpak-wine (5.22)" --width=240 --height=300 \
					 --list \
					 --radiolist --column " " \
					 --column "Action" \
							  0 "Run Winetricks..." \
							  0 "Install Custom DLLs..." \
							  0 "Launch Winecfg..." \
						   TRUE "Open Explorer++" \
							  0 "Delete Bottle" \
					 --text "Select Action for ~/.wine-x86_64 " )

   # exit when Cancel is clicked
   [[ -z "$choice" ]] && exit 1
   
	if [ "$choice" = "Run Winetricks..." ]; then  
	   WINEPREFIX=~/.wine-x86_64 winetricks --gui

    # mydlls
	elif [ "$choice" = "Install Custom DLLs..." ]; then
	mydlls=$(zenity --title "Install custom dlls" --text "paste winetricks (e.g. dv9k dxvk xna31 d3dx9 xinput faudio)" --entry)
    if [ -z $mydlls ]; #if no dlls are given
       then         
       mydlls=(xact xact_x64 xinput xna31 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 d3dx9 faudio)
    else   
    mydlls=( $mydlls ) ; #convert string to array
    fi
    
size=${#mydlls[*]}
step=$(expr 100 / $size)
prog=$(echo $step)
echo $size $step ${mydlls[*]}

	( for i in ${mydlls[*]};
	  do
    	echo $prog
	    echo "# Installing $i..."
	    WINEPREFIX=~/.wine-x86_64 winetricks --unattended  $i
      
        prog=$(expr $prog + $step)
	  done
	  echo 100
	  echo "# Done!"
	) | zenity --width=340 --title "Installing Custom DLLs with Winetricks" --progress --auto-kill
	
	# winecfg
	elif [ "$choice" = "Launch Winecfg..." ]; then
	   WINEPREFIX=~/.wine-x86_64 winecfg

	elif [ "$choice" = "Delete Bottle" ]; then
	   rm -rfv ~/.wine-x86_64; 
       rm ~/.local/share/applications/wine-x86_64/killall_wine-5.22.desktop

	elif [ "$choice" = "Open Explorer++" ]; then
	   WINEPREFIX=~/.wine-x86_64 wine /app/explorer++/Explorer++.exe
	   
	else
	   WINEPREFIX=~/.wine-x86_64 wine /app/explorer++/Explorer++.exe

	fi
    # /for GUI Dialog

# For commandline
elif   [ "$1" == "winecfg" ] ; then
	/app/bin/winecfg
	
elif [ "$1" == "regedit" ] ; then
	$WINEEXE regedit

elif [ "$1" == "Run Winetricks..." ] ; then
	ARGV=$(echo $ARGV|sed 's/winetricks//g')
	$WINETRICKS $ARGV
	
elif [ "$1" == "bash" ] ; then
	bash 
	
else
#	$WINEEXE "$EXE" $@
     cd "$dire" 2>/dev/null;#go to the exe directory then run
     #echo $PWD - pwd >> ~/Documents/debug.txt
     #echo now at $dire >> ~/Documents/debug.txt

	$WINEEXE "$ARGV"
	exit $?
fi
