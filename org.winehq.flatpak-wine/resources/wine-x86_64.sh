#!/bin/bash
export WINEPREFIX=~/.wine-x86_64
export WINEARCH=win64
#export WINEDLLOVERRIDES="mscoree,mshtml="
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
Exec=flatpak kill org.winehq.flatpak-wine
Name=flatpak-wine kill (5.0.4)
Type=Application
Categories=Application;;
Icon=org.winehq.flatpak-wine-kill
Keywords=flatpak; wine; kill;
' > ~/.local/share/applications/wine-x86_64/killall_wine-5.0.4.desktop

# if no argument passed then show a dialog with choices
if [ $# -eq 0 ];  then
   echo "No arguments supplied"
   echo "launching explorer++"
   
   # for GUI Dialog
   choice=$(zenity --title "flatpak-wine (5.0.4)" --width=240 --height=300 \
					 --list \
					 --radiolist --column " " \
					 --column "Action" \
							  0 "Winetricks" \
							  0 "Install_DLLs" \
							  0 "Winecfg" \
						   TRUE "Explore" \
							  0 "Delete_Bottle" \
					 --text "Select Action for ~/.wine-x86_64 " )

   # exit when Cancel is clicked
   [[ "$?" != "0" ]] && exit 1
   
	if [ $choice = "Winetricks" ]; then  
	   WINEPREFIX=~/.wine-x86_64 winetricks --gui

	elif [ $choice = "Install_DLLs" ]; then
	(
	  echo 5
	  echo "# Installing xact..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended xact xact_x64

	  echo 10
	  echo "# Installing xinput..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended xinput

	  echo 15
	  echo "# Installing xna31..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended xna31

	  echo 20
	  echo "# Installing vcrun6..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun6

	  echo 25
	  echo "# Installing vcrun6sp6..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun6sp6

	  echo 30
	  echo "# Installing vcrun 2003..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2003 

	  echo 35
	  echo "# Installing vcrun 2005..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2005 

	  echo 40
	  echo "# Installing vcrun 2008..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2008

	  echo 45
	  echo "# Installing vcrun 2010..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2010
	  
	  echo 50
	  echo "# Installing vcrun 2012..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2012

	  echo 55
	  echo "# Installing vcrun 2013..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2013 	  

	  echo 60
	  echo "# Installing vcrun 2015..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2015

	  echo 65
	  echo "# Installing vcrun 2017..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2017
	  
	  echo 70
	  echo "# Installing vcrun 2019..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended vcrun2019
	  
	  echo 75
	  echo "# Installing corefonts..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended corefonts	  

	  echo 80
	  echo "# Installing d3dx9..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended d3dx9

	  echo 90
	  echo "# Installing allcodecs..."
	  WINEPREFIX=~/.wine-x86_64 winetricks --unattended allcodecs
	  
	  echo 100
	  echo "# Done!"
	) | zenity --title "Installing DLLs with Winetricks" --progress --auto-kill

	elif [ $choice = "Winecfg" ]; then
	   WINEPREFIX=~/.wine-x86_64 winecfg

	elif [ $choice = "Delete_Bottle" ]; then
	   rm -rfv ~/.wine-x86_64; 
       rm ~/.local/share/applications/wine-x86_64/killall_wine-5.0.4.desktop

	elif [ $choice = "Explore" ]; then
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
