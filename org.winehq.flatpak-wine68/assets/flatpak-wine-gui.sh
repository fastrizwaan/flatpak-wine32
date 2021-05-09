#!/bin/bash

#!/bin/bash
export WINEPREFIX=~/.local/share/flatpak-wine/default
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
mkdir -p ~/.local/share/applications/flatpak-wine/


   # sandboxify by rm links to user's ~/Documents ~/Downloads ~/Videos etc.
   if [ ! -f ~/.local/share/flatpak-wine/default.symlinks-removed ]; then
      WINEDLLOVERRIDES="mscoree,mshtml=" WINEPREFIX=~/.local/share/flatpak-wine/default wineboot -u && \
      rm -rf ~/.local/share/flatpak-wine/default/drive_c/users/$USER/Desktop
	  rm -rf ~/.local/share/flatpak-wine/default/drive_c/users/$USER/Downloads
	  rm -rf ~/.local/share/flatpak-wine/default/drive_c/users/$USER/'My Documents'
	  rm -rf ~/.local/share/flatpak-wine/default/drive_c/users/$USER/'My Music'
	  rm -rf ~/.local/share/flatpak-wine/default/drive_c/users/$USER/'My Pictures'
	  rm -rf ~/.local/share/flatpak-wine/default/drive_c/users/$USER/'My Videos' 
	  rm -rf ~/.local/share/flatpak-wine/default/drive_c/users/$USER/Templates

	  #Create normal folders for the deleted symlinks
	  mkdir -p ~/.local/share/flatpak-wine/default/drive_c/users/$USER/Desktop
	  mkdir -p ~/.local/share/flatpak-wine/default/drive_c/users/$USER/Downloads
	  mkdir -p ~/.local/share/flatpak-wine/default/drive_c/users/$USER/'My Documents'
	  mkdir -p ~/.local/share/flatpak-wine/default/drive_c/users/$USER/'My Music'
	  mkdir -p ~/.local/share/flatpak-wine/default/drive_c/users/$USER/'My Pictures'
	  mkdir -p ~/.local/share/flatpak-wine/default/drive_c/users/$USER/'My Videos' 
	  mkdir -p ~/.local/share/flatpak-wine/default/drive_c/users/$USER/Templates

	  touch ~/.local/share/flatpak-wine/default.symlinks-removed
   fi


# flatpak-wine-gui.sh
# for GUI Dialog
if [ $# -eq 0 ];  then
   echo "No arguments supplied; use --help"
 
   choice=$(zenity --title "flatpak-wine (6.8)" --width=240 --height=300 \
					 --list \
					 --radiolist --column " " \
					 --column "Action" \
							  0 "Run Winetricks..." \
							  0 "Install Custom DLLs..." \
							  0 "Launch Winecfg..." \
						   TRUE "Open Explorer++" \
						      0 "Open Shell..." \
                              0 "Kill all Instances" \
							  0 "Delete Bottle" \
					 --text "Select Action for ~/.local/share/flatpak-wine/default " )

   # exit when Cancel is clicked
   [[ -z "$choice" ]] && exit 1
   
	if [ "$choice" = "Run Winetricks..." ]; then  
	   WINEPREFIX=~/.local/share/flatpak-wine/default $WINETRICKS --gui

    # mydlls
	elif [ "$choice" = "Install Custom DLLs..." ]; then
	mydlls=$(zenity --title "Install custom dlls - Paste your list " --text "or Press enter to install (xact xinput xna31 vcrun2003-2012 d3dx9 d9vk)" --entry)
    if [ -z $mydlls ]; #if no dlls are given
       then         
       mydlls=(xact xact_x64 xinput xna31 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 d3dx9 d9vk faudio)
    else   
    mydlls=( $mydlls ) ; #convert string to array
    fi
    
size=${#mydlls[*]}
size=$(expr $size + 1) ;# add +1 for progress

step=$(expr 100 / $size)
prog=$(echo $step)
echo $size $step ${mydlls[*]}

	( for i in ${mydlls[*]};
	  do
    	echo $prog
	    echo "# Installing $i..."
	    WINEPREFIX=~/.local/share/flatpak-wine/default $WINETRICKS --unattended  $i
      
        prog=$(expr $prog + $step)
	  done
	  echo 100
	  echo "# Done!"
	) | zenity --width=340 --title "Installing Custom DLLs with Winetricks" --progress --auto-kill
	
	# winecfg
	elif [ "$choice" = "Launch Winecfg..." ]; then
	   WINEPREFIX=~/.local/share/flatpak-wine/default winecfg
       
    elif [ "$choice" = "Kill all Instances" ]; then
	   flatpak-spawn --host flatpak kill org.winehq.flatpak-wine
    elif [ "$choice" = "Open Shell..." ]; then   
       flatpak-spawn --host gnome-terminal -- bash -c "flatpak run org.winehq.flatpak-wine bash"
	elif [ "$choice" = "Delete Bottle" ]; then
	   rm -rfv ~/.local/share/flatpak-wine/default; 
	   rm -f   ~/.local/share/flatpak-wine/default.symlinks-removed

	elif [ "$choice" = "Open Explorer++" ]; then
	   WINEPREFIX=~/.local/share/flatpak-wine/default $WINEEXE /app/explorer++/Explorer++.exe
	   
	else
	   WINEPREFIX=~/.local/share/flatpak-wine/default $WINEEXE /app/explorer++/Explorer++.exe

	fi
    # /for GUI Dialog
else


   # Prompt to open with Bottle if already bottle is created
   basefilename=$(basename "$1")
   basefilename_underscore=$(echo $basefilename|tr ' ' '_')
   echo $basefilename
   ls ~/.local/share/flatpak-wine/bottles/"$basefilename.sh"
   
   if [ -f  ~/.local/share/flatpak-wine/bottles/"$basefilename_underscore.sh" ]; then
   
      choice=$(zenity --title "flatpak-wine (6.8)" --width=500 --height=300 \
	    				 --list \
		    			 --radiolist --column " " \
			    		 --column "Action" \
						   0 "Run $basefilename using Default bottle" \
						TRUE "Run $basefilename using existing $basename bottle" \
						   0 "Run $basefilename configuration" \
					 --text "Select Action for ~/.local/share/flatpak-wine/default " )
   else
   choice=$(zenity --title "flatpak-wine (6.8)" --width=500 --height=300 \
					 --list \
					 --radiolist --column " " \
					 --column "Action" \
						   TRUE "Run $basefilename using Default bottle" \
							  0 "Create Bottle for $basefilename" \
					 --text "Select Action for ~/.local/share/flatpak-wine/default " )
    fi
   # exit when Cancel is clicked
   [[ -z "$choice" ]] && exit 1
   
	if [ "$choice" = "Run $basefilename using Default bottle" ]; then  
	   cd "$dire" 2>/dev/null;#go to the exe directory then run
       WINEPREFIX=~/.local/share/flatpak-wine/default $WINEEXE "$@"

    # Create bottle
	elif [ "$choice" = "Create Bottle for $basefilename" ]; then
         /app/bin/wine-create-bottle.sh "$1"
    elif [ "$choice" = "Run $basefilename using existing $basename bottle" ]; then
	    # We are replace "name with space" as "name_with_space"
	    basefilename_underscore=$(echo $basefilename|tr ' ' '_')
	    flatpak-spawn --host ~/.local/share/flatpak-wine/bottles/"$basefilename_underscore.sh" "launch"
	elif [ "$choice" = 	"Run $basefilename configuration" ]; then
		basefilename_underscore=$(echo $basefilename|tr ' ' '_')
	    flatpak-spawn --host ~/.local/share/flatpak-wine/bottles/"$basefilename_underscore.sh"
	fi
	

fi

