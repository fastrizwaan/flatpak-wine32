#!/usr/bin/env bash
# ============================================================================ #
# This script will create a shortcut on applications menu for windows programs 
# installed with wine.
# Autor: Thiago silva
# Contact: thiagos.dasilva@gmail.com
# URL: https://github.com/thiggy01/wine-create-shortcut
# Updated by Mohammed Asif Ali Rizvan for wine bottle
# ============================================================================ #

# Check if an application argument was submited.
if [[ $(file --mime-type -b "$1") = application/* ]]; then

    # Get the full path, the name and directory name of submited application file.
    myFile=$(realpath "$1")
    myBaseName=$(basename "$myFile")
    myPath=$(dirname "$myFile")

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
    cp "$(ls -S -1 "/tmp/$myBaseName"*".png"  | head -n 1)" "$myFile.icon.png"

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
mkdir -p ~/.wine-x86_64-bottles/

myBaseNamePrefix=$(echo $myBaseName|tr ' ' '_');

###############################################
cat << EOF > ~/.wine-x86_64-bottles/$myBaseNamePrefix.sh
#!/bin/bash
export WINEPREFIX=~/.wine-x86_64-bottles/$myBaseNamePrefix
export WINEARCH=win64
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/app/lib:/app/lib32:/app/lib/wine:/app/lib32/wine:/app/lib/i386-linux-gnu:/app/lib/debug/lib/i386-linux-gnu

choice=\$(zenity --title "$myBaseNamePrefix: Choose!" --width=240 --height=300 \
                 --list \
                 --radiolist --column " " \
                 --column "Action" \
                          0 "My_Dlls_install" \
                          0 "Install_DLLs" \
                          TRUE "Launch $myBaseNamePrefix" \
                          0 "Winetricks" \
                          0 "Winecfg" \
                          0 "Explore" \
                          0 "Shell" \
                          0 "Delete_Bottle" \
                 --text "Select Action..." )


[[ -z "\$choice" ]] && exit 1

if [ "\$choice" = "Winetricks" ]; then  
   WINEPREFIX=~/.wine-x86_64-bottles/$myBaseNamePrefix flatpak run --command=winetricks org.winehq.flatpak-wine --gui

elif [ "\$choice" = "Install_DLLs" ]; then

#recommeded https://www.youtube.com/watch?v=aDuysgB35YY
dlls=(xna31 quartz vcrun2005 vcrun2008 vcrun2010 vcrun2012 wininet xact xact_x64 xinput d3dx10_43 d3dx10 d3dx11_42 d3dx11_43 d3dx9_24 d3dx9_25 d3dx9_26 d3dx9_27 d3dx9_28 d3dx9_29 d3dx9_30 d3dx9_31 d3dx9_32 d3dx9_33 d3dx9_34 d3dx9_35 d3dx9_36 d3dx9_37 d3dx9_38 d3dx9_39 d3dx9_40 d3dx9_41 d3dx9_42 d3dx9_43 d3dx9 d3dxof corefonts faudio directplay directmusic corefonts)

#dlls=(xact xact_x64 xinput xna31 vcrun6 vcrun6sp6 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 vcrun2017 vcrun2019 corefonts d3dx9 allcodecs)

size=\${#dlls[*]}
step=\$(expr 100 / \$size)
prog=\$(echo \$step)


	( for i in \${dlls[*]};
	  do
    	echo \$prog
	    echo "# Installing \$i..."
	    WINEPREFIX=~/.wine-x86_64-bottles/$myBaseNamePrefix flatpak run --command=winetricks org.winehq.flatpak-wine --unattended  \$i
      
        prog=\$(expr \$prog + \$step)
	  done
	  echo 100
	  echo "# Done!"
	) | zenity --width=340 --title "$myBaseNamePrefix: Installing DLLs with Winetricks" --progress --auto-kill


    # My_Dlls_install
	elif [ "\$choice" = "My_Dlls_install" ]; then
	mydlls=\$(zenity --title "Install custom dlls" --text "paste winetricks (e.g., xna31 d3dx9 xinput faudio)" --entry)
    if [ -z \$mydlls ]; #if no dlls are given
       then         
       mydlls=(xact xact_x64 xinput xna31 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 d3dx9 faudio)
    else
    mydlls=( \$mydlls ) ; #convert string to array
    fi
size=\${#mydlls[*]}
step=\$(expr 100 / \$size)
prog=\$(echo \$step)

	( for i in \${mydlls[*]};
	  do
    	echo \$prog
	    echo "# Installing \$i..."
	    WINEPREFIX=~/.wine-x86_64-bottles/$myBaseNamePrefix flatpak run --command=winetricks org.winehq.flatpak-wine --unattended \$i
      
        prog=\$(expr \$prog + \$step)
	  done
	  echo 100
	  echo "# Done!"
	) | zenity --width=340 --title "$myBaseNamePrefix: Installing Custom DLLs with Winetricks" --progress --auto-kill


elif [ "\$choice" = "Winecfg" ]; then
   WINEPREFIX=~/.wine-x86_64-bottles/$myBaseNamePrefix flatpak run --command=winecfg org.winehq.flatpak-wine
elif [ "\$choice" = "Explore" ]; then
   WINEPREFIX=~/.wine-x86_64-bottles/$myBaseNamePrefix flatpak run --command=wine org.winehq.flatpak-wine /app/explorer++/Explorer++.exe
elif [ "\$choice" = "Shell" ]; then   
 gnome-terminal -- bash -c "flatpak run --command=bash org.winehq.flatpak-wine"
elif [ "\$choice" = "Delete_Bottle" ]; then
rm -rfv ~/.wine-x86_64-bottles/$myBaseNamePrefix; 
rm -f "$HOME/.local/share/applications/wine-x86_64/$myBaseName.desktop"
rm -f "$myFile.desktop" 
rm -f "$myFile.icon.png"
rm -f ~/.wine-x86_64-bottles/"$myBaseNamePrefix.sh"
else
export base=\$(basename "$myFile")
export dire=\$(dirname "$myFile")
cd "\$dire"
WINEPREFIX=~/.wine-x86_64-bottles/$myBaseNamePrefix flatpak run --command=wine org.winehq.flatpak-wine "\$base"
fi
EOF

###############################################
chmod +x ~/.wine-x86_64-bottles/"$myBaseNamePrefix.sh"
chmod +x ~/.wine-x86_64-bottles/*.sh
    
    # Generate desktop entry specifications to be added to the application launcher.
    deskEntry="[Desktop Entry]"\\n"Exec=bash -c ~/.wine-x86_64-bottles/$myBaseNamePrefix.sh"\\n"Name=\
$appName"\\n"Path=$myPath"\\n"Type=Application"\\n"Categories=$appCategory;\
$category;"\\n"Icon="$myFile.icon.png""
    # Create a .desktop file and add desktop entries in it.
    echo -e $deskEntry >"$myFile".desktop
    echo "Keywords=flatpak; wine;" >> "$myFile".desktop
    
    # link the launcher  file to a shortcut on applications menu.
    mkdir -p "$HOME/.local/share/applications/wine-x86_64/"
    
    ln -sf "$myFile".desktop  $HOME/.local/share/applications/wine-x86_64/"$myBaseName".desktop
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
