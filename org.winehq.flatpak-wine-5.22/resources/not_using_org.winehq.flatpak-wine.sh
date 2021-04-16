#!/bin/sh

if [ $# -eq 0 ]; then

	choice=$(zenity  --title "What do you want?" --width=240 --height=300 \
					 --list \
					 --radiolist --column " " \
					 --column "Action" \
						   TRUE "Explore" \
							  0 "Winetricks" \
							  0 "Install_DLLs" \
							  0 "Winecfg" \
							  0 "Kill" \
							  0 "Shell" \
							  0 "Delete_Bottle" \
					 --text "Select Action..." )

	if [ "$choice" = "Winetricks" ]; then  
	   WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --gui
	elif [ "$choice" = "Install_DLLs" ]; then
	(
	  echo 10
	  echo "# Installing xact..."
	  WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --unattended xact xact_x64

	  echo 20
	  echo "# Installing xinput..."
	  WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --unattended xinput

	  echo 40
	  echo "# Installing XNA31..."
	  WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --unattended xna31

	  echo 50
	  echo "# Installing vcrun 2005..."
	  WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --unattended vcrun2005 

	  echo 60
	  echo "# Installing vcrun 2008..."
	  WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --unattended vcrun2008

	  echo 70
	  echo "# Installing corefonts..."
	  WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --unattended vcrun2008

	  echo 80
	  echo "# Installing d3dx9..."
	  WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --unattended d3dx9

	  echo 90
	  echo "# Installing allcodecs..."
	  WINEPREFIX=~/.wine-x86_64 flatpak run --command=winetricks org.winehq.wine-x86_64 --unattended allcodecs
	  
	  echo 100
	  echo "# Done!"
	) | zenity --title "Installing DLLs with Winetricks" --progress --auto-kill

	elif [ "$choice" = "Winecfg" ]; then
	   WINEPREFIX=~/.wine-x86_64 flatpak run --command=winecfg org.winehq.wine-x86_64
	elif [ "$choice" = "Explore" ]; then
	   WINEPREFIX=~/.wine-x86_64 flatpak run --command=wine org.winehq.wine-x86_64 /app/explorer++/Explorer++.exe
	elif [ "$choice" = "Shell" ]; then   
	 gnome-terminal -- bash -c "WINEPREFIX=~/.wine-x86_64 flatpak run --command=bash org.winehq.wine-x86_64"
	elif [ "$choice" = "Delete_Bottle" ]; then
	rm -rfv ~/.wine-x86_64;
	elif [ "$choice" = "Kill" ]; then 
	   WINEPREFIX=~/.wine-x86_64 flatpak kill org.winehq.wine-x86_64 "$@"
	fi
else
	   WINEPREFIX=~/.wine-x86_64 flatpak run org.winehq.wine-x86_64 "$@"
fi 

