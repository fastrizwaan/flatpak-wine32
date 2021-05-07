#!/usr/bin/env bash
# ============================================================================ #
# This script will create a shortcut on applications menu for windows programs 
# installed with wine.
# Autor: Thiago silva
# Contact: thiagos.dasilva@gmail.com
# URL: https://github.com/thiggy01/wine-create-shortcut
# Updated by Mohammed Asif Ali Rizvan for wine bottle
# URL: https://github.com/fastrizwaan/flatpak-wine
# ============================================================================ #

# Check if an application argument was submited.
if [[ $(file --mime-type -b "$1") = application/* ]]; then

    # Get the full path, the name and directory name of submited application file.
    myFile=$(realpath "$1")
    myBaseName=$(basename "$myFile")
    myPath=$(dirname "$myFile")
	myBaseNamePrefix=$(echo $myBaseName|tr ' ' '_');
    bottles_dir="$HOME/.local/share/flatpak-wine/bottles/$myBaseNamePrefix"    
    mkdir -p "$HOME/.local/share/applications/flatpak-wine/$myBaseNamePrefix"

    # Function to verify if required program is installed.
    VerInst () {
	if [ $? -eq 127 ]; then
	    echo "$1 package is not installed."
	    echo "Install it before running this script."
	    echo "Aborting."
	    exit 1
	fi
    }

    # Extract icon and convert it to several png files of diferent quality, 
    wrestool -x -t 14 "$myFile" > "/tmp/$myBaseName.ico" 2> /dev/null
    VerInst icoutils
    convert -alpha on "/tmp/$myBaseName.ico" "/tmp/$myBaseName.png" 2> /dev/null
    VerInst imagemagick
    # Select the best png image file.
    cp "$(ls -S -1 "/tmp/$myBaseName"*".png"  | head -n 1)" "$bottles_dir.icon.png"

    # Get the app category and shortcut name inputs from the user.
    appCategory=$(zenity --title "wine-create-shortcut" --height=450 --list \
 --radiolist --column " " --column "Categories" 0 AudioVideo 0 Audio 0 Video 0 \
 Development 0 Education TRUE Game 0 Graphics 0 Network 0 Office 0 Settings 0 \
 System 0 Utility  --text "Select a Category:" 2> /dev/null)


    VerInst zenity
    appName=$(zenity --title "wine-create-shortcut" --text "Enter a name for your \
shortcut" --entry)

    if [ ! $appName ]; #if no name is given use filename
       then         
       appName=$(echo "$myBaseName");     
    fi


# try to add wineprefix for the game
mkdir -p ~/.local/share/flatpak-wine/bottles/


###############################################
cat << EOF > ~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix.sh
#!/bin/bash
export WINEPREFIX=~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix
export WINEARCH=win64
export WINEDLLOVERRIDES="mscoree,mshtml="
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/app/lib:/app/lib32:/app/lib/wine:/app/lib32/wine:/app/lib/i386-linux-gnu:/app/lib/debug/lib/i386-linux-gnu



   # If wineprefix is not created, create without annoying dotnet and gecko dialogs
   #WINEDLLOVERRIDES="mscoree,mshtml=" WINEPREFIX=~/.local/share/flatpak-wine/default wineboot -u
   
   # Remove ~/Documents ~/Downloads ~/Videos etc. symlinks
   if [ ! -f ~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix.symlinks-removed ]; then
      WINEDLLOVERRIDES="mscoree,mshtml=" WINEPREFIX=~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix wineboot -u && \
      rm -rf ~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix/drive_c/users && \
	  touch ~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix.symlinks-removed
   fi
   
# Launch game from flatpak-wine-gui.sh - Run with bottle
if [ "\$1" = "launch" ]; then
export base=\$(basename "$myFile")
export dire=\$(dirname "$myFile")
cd "\$dire"
WINEPREFIX=~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix flatpak run --command=wine org.winehq.flatpak-wine "\$base"
exit 0;
fi
# /Launch game from flatpak-wine-gui.sh


choice=\$(zenity --title "$myBaseNamePrefix: Choose!" --width=340 --height=480 \
                 --list \
                 --radiolist --column " " \
                 --column "Action" \
                          0 "Install Custom DLLs..." \
                          TRUE "Launch $myBaseNamePrefix" \
                          0 "Run Winetricks..." \
                          0 "Launch Winecfg..." \
                          0 "Open Explorer++..." \
                          0 "Open Shell..." \
						  0 "Rename..." \
						  0 "Backup..." \
                          0 "Delete Bottle: $myBaseNamePrefix" \
                 --text "Select Action..." )


[[ -z "\$choice" ]] && exit 1

if [ "\$choice" = "Run Winetricks..." ]; then  
   WINEPREFIX=~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix flatpak run --command=winetricks org.winehq.flatpak-wine --gui

    # My_Dlls_install
	elif [ "\$choice" = "Install Custom DLLs..." ]; then
	mydlls=\$(zenity --title "Install custom dlls" --text "paste winetricks (e.g. dv9k dxvk xna31 d3dx9 xinput faudio)" --entry)
    if [ -z \$mydlls ]; #if no dlls are given
       then         
       mydlls=(xact xact_x64 xinput xna31 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 d3dx9 d9vk faudio)
    else
    mydlls=( \$mydlls ) ; #convert string to array
    fi
size=\${#mydlls[*]}
size=\$(expr \$size + 1) ;# add +1 for progress
step=\$(expr 100 / \$size)
step=\$(expr \$step + 1)
prog=\$(echo \$step)

	( for i in \${mydlls[*]};
	  do
    	echo \$prog
	    echo "# Installing \$i..."
	    WINEPREFIX=~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix flatpak run --command=winetricks org.winehq.flatpak-wine --unattended \$i
      
        prog=\$(expr \$prog + \$step)
	  done
	  echo 100
	  echo "# Done!"
	) | zenity --width=340 --title "$myBaseNamePrefix: Installing Custom DLLs with Winetricks" --progress --auto-kill


elif [ "\$choice" = "Launch Winecfg..." ]; then
   WINEPREFIX=~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix flatpak run --command=winecfg org.winehq.flatpak-wine
elif [ "\$choice" = "Open Explorer++..." ]; then
   WINEPREFIX=~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix flatpak run --command=wine org.winehq.flatpak-wine /app/explorer++/Explorer++.exe
elif [ "\$choice" = "Open Shell..." ]; then   
 gnome-terminal -- bash -c "flatpak run --command=bash org.winehq.flatpak-wine"
 
elif [ "\$choice" = "Rename..." ]; then
     appName=\$(zenity --title "Rename shortcut" --text "Enter a name for your \
shortcut" --entry)

    if [ ! \$appName ]; #if no name is given use filename
       then 
       zenity --info --title="Shortcut... " --text="no Change"        
       exit;
    fi
    desktop-file-edit --set-name="\$appName" \$HOME/.local/share/applications/flatpak-wine/"$myBaseName".desktop 
	zenity --info --title="Shortcut renamed sucessfuly: \$appname " --text="$myBaseName.desktop"

elif [ "\$choice" = "Backup..." ]; then
     DATE=\$(date +'%Y%m%d')
     mkdir -p \$HOME/flatpak-wine-backup;
	 tar -zcvf "\$HOME/flatpak-wine-backup/flatpak-wine-bottle-$myBaseNamePrefix-\$DATE.tar.gz" \
			~/.local/share/flatpak-wine/bottles/"$myBaseNamePrefix"          \
			~/.local/share/flatpak-wine/bottles/"$myBaseNamePrefix.sh"       \
			~/.local/share/flatpak-wine/bottles/"$myBaseNamePrefix.desktop"  \
			~/.local/share/flatpak-wine/bottles/"$myBaseNamePrefix.icon.png" \
	     && zenity --info --title="Bottle backed up: $myBaseNamePrefix" --text="flatpak-wine-bottle-$myBaseNamePrefix-\$DATE.tar.gz at \$HOME/flatpak-wine-backup"



elif [ "\$choice" = "Delete Bottle: $myBaseNamePrefix" ]; then
rm -rfv ~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix; 
rm -f "$HOME/.local/share/applications/flatpak-wine/$myBaseName.desktop"
rm -f "$bottles_dir.desktop" 
rm -f "$bottles_dir.icon.png"
rm -f ~/.local/share/flatpak-wine/bottles/"$myBaseNamePrefix.sh"
rm -f ~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix.symlinks-removed
elif [ "\$choice" = "Launch $myBaseNamePrefix" ]; then
export base=\$(basename "$myFile")
export dire=\$(dirname "$myFile")
cd "\$dire"
WINEPREFIX=~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix flatpak run --command=wine org.winehq.flatpak-wine "\$base"
fi
EOF

###############################################
chmod +x ~/.local/share/flatpak-wine/bottles/"$myBaseNamePrefix.sh"
chmod +x ~/.local/share/flatpak-wine/bottles/*.sh

    # Generate desktop entry specifications to be added to the application launcher.
    deskEntry="[Desktop Entry]"\\n"Exec=bash -c ~/.local/share/flatpak-wine/bottles/$myBaseNamePrefix.sh"\\n"Name=\
$appName"\\n"Path=$myPath"\\n"Type=Application"\\n"Categories=$appCategory;\
$category;"\\n"Icon="$bottles_dir.icon.png""
    # Create a .desktop file and add desktop entries in it.
    echo -e $deskEntry >"$bottles_dir".desktop
    echo "Keywords=flatpak; wine;" >> "$bottles_dir".desktop
    
    # link the launcher  file to a shortcut on applications menu.
    mkdir -p "$HOME/.local/share/applications/flatpak-wine/"
    
    ln -sf "$bottles_dir".desktop  $HOME/.local/share/applications/flatpak-wine/"$myBaseName".desktop
    # Test if the app link was created sucessfully on applications menu 
    if [ $? -eq 0 ]; then
        gtk-update-icon-cache 
        update-desktop-database $HOME/.local/share/applications 
        update-desktop-database "$myPath"
    	echo "Shortcut created sucessfuly on applications menu."
    	zenity --info --title="Shortcut created sucessfuly " --text="$myBaseName.desktop"
    fi

else 

# If no application was submited, show this message.
	echo Please, submit a windows application file. 
	echo Usage: ./wine-create-shortcut path/to/app.exe 
	zenity --info --title="Select an EXE to create shortcut" --text="in Filemanager, right-click on an exe and select this!"

fi
