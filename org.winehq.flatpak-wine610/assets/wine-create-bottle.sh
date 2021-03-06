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
    bottles_dir="$HOME/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix"    
	
	# application shortcut folder
    mkdir -p "$HOME/.local/share/applications/flatpak-wine610/$myBaseNamePrefix"
    mkdir -p "$bottles_dir"
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
       appName=$(echo "$myBaseName (6.10)");     
    else 
       appName=$(echo "$appName (6.10)");   
    fi


# try to add wineprefix for the game
mkdir -p ~/.local/share/flatpak-wine610/bottles/


###############################################
cat << EOF > ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix.sh
#!/bin/bash
export WINEPREFIX=~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix
export WINEARCH=win64
export WINEDLLOVERRIDES="mscoree,mshtml="
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/app/lib:/app/lib32:/app/lib64:/app/lib/i386-linux-gnu:/app/lib/wine:/app/lib64/wine:/app/\$NAME:\$(pwd)

# Remove wine shortcuts before creating new bottles
# rm -rfv ~/.var/app/org.winehq.flatpak-wine/data/applications/wine*

  
   # Remove sandboxify by rm links to ~/Documents ~/Downloads ~/Videos etc.
   if [ ! -f ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix.symlinks-removed  ]; then
   
   
     rm ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/Desktop   
     rm ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/Downloads
	  rm ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/'My Documents'
	  rm ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/'My Music'
	  rm ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/'My Pictures'
	  rm ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/'My Videos' 
	  rm ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/Templates

	  #Create normal folders for the deleted symlinks
	  mkdir -p ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/Desktop
	  mkdir -p ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/Downloads
	  mkdir -p ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/'My Documents'
	  mkdir -p ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/'My Music'
	  mkdir -p ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/'My Pictures'
	  mkdir -p ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/'My Videos' 
	  mkdir -p ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix/drive_c/users/\$USER/Templates

	  touch ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix.symlinks-removed 
   fi

   
# Launch game from flatpak-wine-gui.sh - Run with bottle
if [ "\$1" = "launch" ]; then
export base=\$(basename "$myFile")
export dire=\$(dirname "$myFile")
cd "\$dire"
flatpak run --command=wine org.winehq.flatpak-wine610 "\$base"
exit 0;
fi
# /Launch game from flatpak-wine-gui.sh


choice=\$(zenity --title "$myBaseNamePrefix: Choose!" --width=340 --height=400 \
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
						  0 "Change Icon..." \
						  0 "Backup..." \
                          0 "Delete Bottle: $myBaseNamePrefix" \
                 --text "Select Action..." )


[[ -z "\$choice" ]] && exit 1

if [ "\$choice" = "Run Winetricks..." ]; then  
flatpak run --command=winetricks org.winehq.flatpak-wine610 --gui

    # My_Dlls_install
	elif [ "\$choice" = "Install Custom DLLs..." ]; then
	mydlls=\$(zenity --title "Install custom dlls" --text "paste winetricks (e.g. dv9k dxvk xna31 d3dx9 xinput faudio)" --entry)
    if [ -z \$mydlls ]; #if no dlls are given
       then         
       mydlls=(xact xact_x64 xinput xna31 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2015 vcrun2019 d3dx9 d9vk faudio quartz dotnet48)
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
	    flatpak run --command=winetricks org.winehq.flatpak-wine610 --force --unattended \$i
      
        prog=\$(expr \$prog + \$step)
	  done
	  echo 100
	  echo "# Done!"
	) | zenity --width=340 --title "$myBaseNamePrefix: Installing Custom DLLs with Winetricks" --progress --auto-kill


elif [ "\$choice" = "Launch Winecfg..." ]; then
flatpak run --command=winecfg org.winehq.flatpak-wine610
elif [ "\$choice" = "Open Explorer++..." ]; then
flatpak run --command=wine org.winehq.flatpak-wine610 /app/explorer++/Explorer++.exe
elif [ "\$choice" = "Open Shell..." ]; then   
 gnome-terminal -- bash -c "flatpak run --command=bash org.winehq.flatpak-wine610"
 
elif [ "\$choice" = "Rename..." ]; then
     appName=\$(zenity --title "Rename shortcut" --text "Enter a name for your \
shortcut" --entry)

    if [ ! \$appName ]; #if no name is given use filename
       then 
       zenity --info --title="Shortcut... " --text="no Change"        
       exit;
    fi
    desktop-file-edit --set-name="\$appName" \$HOME/.local/share/applications/flatpak-wine610/"$myBaseName".desktop 
	update-desktop-database ~/.local/share/applications/
	zenity --info --title="$myBaseName.desktop" --text="Shortcut renamed sucessfuly: \$appname"

elif [ "\$choice" = "Change Icon..." ]; then
     get_icon=\$(zenity --file-selection --file-filter=""*.png" "*.jpg" "*.svg"")
     if [ ! \$get_icon ]; #if no icon is choosen
       then 
       zenity --info --title="Icon... " --text="no Change"        
       exit;
     fi
     desktop-file-edit --set-icon="\$get_icon" \$HOME/.local/share/applications/flatpak-wine610/"$myBaseName".desktop 
	 update-desktop-database ~/.local/share/applications/
	 zenity --info --title="$myBaseName.desktop" --text="Icon Changed sucessfuly: \$get_icon"



elif [ "\$choice" = "Backup..." ]; then
     DATE=\$(date +'%Y%m%d')
     mkdir -p \$HOME/flatpak-wine610-backup;
	 tar -zcvf "\$HOME/flatpak-wine610-backup/flatpak-wine610-bottle-$myBaseNamePrefix-\$DATE.tar.gz" \
			~/.local/share/flatpak-wine610/bottles/"$myBaseNamePrefix"          \
			~/.local/share/flatpak-wine610/bottles/"$myBaseNamePrefix.sh"       \
			~/.local/share/flatpak-wine610/bottles/"$myBaseNamePrefix.desktop"  \
			~/.local/share/flatpak-wine610/bottles/"$myBaseNamePrefix.icon.png" \
	     && zenity --info --title="Bottle backed up: $myBaseNamePrefix" --text="flatpak-wine610-bottle-$myBaseNamePrefix-\$DATE.tar.gz at \$HOME/flatpak-wine610-backup"



elif [ "\$choice" = "Delete Bottle: $myBaseNamePrefix" ]; then
rm -rfv ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix; 
rm -f "$HOME/.local/share/applications/flatpak-wine610/$myBaseName.desktop"
rm -f "$bottles_dir.desktop" 
rm -f "$bottles_dir.icon.png"
rm -f ~/.local/share/flatpak-wine610/bottles/"$myBaseNamePrefix.sh"
rm -f ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix.symlinks-removed
elif [ "\$choice" = "Launch $myBaseNamePrefix" ]; then
export base=\$(basename "$myFile")
export dire=\$(dirname "$myFile")
cd "\$dire"
flatpak run --command=wine org.winehq.flatpak-wine610 "\$base"
fi
EOF

###############################################
chmod +x ~/.local/share/flatpak-wine610/bottles/"$myBaseNamePrefix.sh"
chmod +x ~/.local/share/flatpak-wine610/bottles/*.sh

    # Generate desktop entry specifications to be added to the application launcher.
    deskEntry="[Desktop Entry]"\\n"Exec=bash -c ~/.local/share/flatpak-wine610/bottles/$myBaseNamePrefix.sh"\\n"Name=\
$appName"\\n"Path=$myPath"\\n"Type=Application"\\n"Categories=$appCategory;\
$category;"\\n"Icon="$bottles_dir.icon.png""
    # Create a .desktop file and add desktop entries in it.
    echo -e $deskEntry >"$bottles_dir".desktop
    echo "Keywords=flatpak; wine;" >> "$bottles_dir".desktop
    
    # link the launcher  file to a shortcut on applications menu.
    mkdir -p "$HOME/.local/share/applications/flatpak-wine610/"
    
    ln -sf "$bottles_dir".desktop  $HOME/.local/share/applications/flatpak-wine610/"$myBaseName".desktop
    # Test if the app link was created sucessfully on applications menu 
    if [ $? -eq 0 ]; then
        gtk-update-icon-cache 
        flatpak-spawn --host update-desktop-database ~/.local/share/applications/
        echo "Shortcut created sucessfuly on applications menu."
    	zenity --info --title="Shortcut created sucessfuly " --text="$myBaseName.desktop"
    fi

else 

# If no application was submited, show this message.
	echo Please, submit a windows application file. 
	echo Usage: ./wine-create-shortcut path/to/app.exe 
	zenity --info --title="Select an EXE to create shortcut" --text="in Filemanager, right-click on an exe and select this!"

fi
