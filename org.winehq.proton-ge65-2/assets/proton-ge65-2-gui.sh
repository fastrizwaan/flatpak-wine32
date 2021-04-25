#!/bin/bash

#!/bin/bash
export WINEPREFIX=~/.local/share/org.winehq.proton-ge65-2/default
export WINEARCH=win64
#export WINEDLLOVERRIDES="mscoree,mshtml="
export LD_LIBRARY_PATH=/app/lib:/app/lib32:/app/lib64:/app/lib/i386-linux-gnu:/app/lib/wine:/app/lib64/wine:/app/$NAME:$(pwd)

export ARGV="$@"
export WINEEXE="/app/bin/wine"
export WINETRICKS="/app/bin/winetricks"


# some games need to cd to the dir to work
export base=$(basename "$1")
export dire=$(dirname  "$1")

#echo $base >> ~/Documents/debug.txt
#echo $dire >> ~/Documents/debug.txt
# Create kill shortcut for convenience
mkdir -p ~/.local/share/applications/org.winehq.proton-ge65-2/

# Create kill shortcut for convenience
mkdir -p ~/.local/share/applications/org.winehq.proton-ge65-2/
echo '
[Desktop Entry]
Exec=flatpak kill org.winehq.org.winehq.proton-ge65-2
Name=Proton-6.5-GE-1 kill (6.5)
Type=Application
Categories=Application;;
Icon=org.winehq.org.winehq.proton-ge65-2-kill
Keywords=flatpak; proton; wine; kill;
' > ~/.local/share/applications/org.winehq.proton-ge65-2/killall_proton-ge65-2.desktop


# org.winehq.proton-ge65-2-gui.sh
# for GUI Dialog
if [ $# -eq 0 ];  then
   echo "No arguments supplied; use --help"
 
   choice=$(zenity --title "Proton-GE-64-1 (6.5)" --width=240 --height=300 \
					 --list \
					 --radiolist --column " " \
					 --column "Action" \
							  0 "Run Winetricks..." \
							  0 "Install Custom DLLs..." \
							  0 "Launch Winecfg..." \
						   TRUE "Open Explorer++" \
							  0 "Delete Bottle" \
					 --text "Select Action for ~/.local/share/org.winehq.proton-ge65-2/default " )

   # exit when Cancel is clicked
   [[ -z "$choice" ]] && exit 1
   
	if [ "$choice" = "Run Winetricks..." ]; then  
	   WINEPREFIX=~/.local/share/org.winehq.proton-ge65-2/default $WINETRICKS --gui

    # mydlls
	elif [ "$choice" = "Install Custom DLLs..." ]; then
	mydlls=$(zenity --title "Install custom dlls - Paste your list " --text "or Press enter to install (xact xinput xna31 vcrun2003-2012 d3dx9 d9vk)" --entry)
    if [ -z $mydlls ]; #if no dlls are given
       then         
       mydlls=(xact xact_x64 xinput xna31 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 d3dx9 d9vk)
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
	    WINEPREFIX=~/.local/share/org.winehq.proton-ge65-2/default $WINETRICKS --unattended  $i
      
        prog=$(expr $prog + $step)
	  done
	  echo 100
	  echo "# Done!"
	) | zenity --width=340 --title "Installing Custom DLLs with Winetricks" --progress --auto-kill
	
	# winecfg
	elif [ "$choice" = "Launch Winecfg..." ]; then
	   WINEPREFIX=~/.local/share/org.winehq.proton-ge65-2/default winecfg

	elif [ "$choice" = "Delete Bottle" ]; then
	   rm -rfv ~/.local/share/org.winehq.proton-ge65-2/default; 
       rm ~/.local/share/applications/org.winehq.proton-ge65-2/killall_proton-ge65-2.desktop

	elif [ "$choice" = "Open Explorer++" ]; then
	   WINEPREFIX=~/.local/share/org.winehq.proton-ge65-2/default $WINEEXE /app/explorer++/Explorer++.exe
	   
	else
	   WINEPREFIX=~/.local/share/org.winehq.proton-ge65-2/default $WINEEXE /app/explorer++/Explorer++.exe

	fi
    # /for GUI Dialog
else
cd "$dire" 2>/dev/null;#go to the exe directory then run
WINEPREFIX=~/.local/share/org.winehq.proton-ge65-2/default $WINEEXE "$@"
fi

