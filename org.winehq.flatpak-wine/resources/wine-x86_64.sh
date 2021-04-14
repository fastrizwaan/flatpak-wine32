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
							  0 "My_Dlls_install" \
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
	
    #recommeded https://www.youtube.com/watch?v=aDuysgB35YY
    dlls=(xna31 quartz vcrun2005 vcrun2008 vcrun2010 wininet xact xact_x64 xinput d3dx10_43 d3dx10 d3dx11_42 d3dx11_43 d3dx9_24 d3dx9_25 d3dx9_26 d3dx9_27 d3dx9_28 d3dx9_29 d3dx9_30 d3dx9_31 d3dx9_32 d3dx9_33 d3dx9_34 d3dx9_35 d3dx9_36 d3dx9_37 d3dx9_38 d3dx9_39 d3dx9_40 d3dx9_41 d3dx9_42 d3dx9_43 d3dx9 d3dxof corefonts faudio directplay directmusic)
	
#dlls=(xact xact_x64 xinput xna31 vcrun6 vcrun6sp6 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 vcrun2017 vcrun2019 corefonts d3dx9 allcodecs faudio)

size=${#dlls[*]}
step=$(expr 100 / $size)
prog=$(echo $step)
echo $size $step ${dlls[*]}

	( for i in ${dlls[*]};
	  do
    	echo $prog
	    echo "# Installing $i..."
	    WINEPREFIX=~/.wine-x86_64 winetricks --unattended  $i
      
        prog=$(expr $prog + $step)
	  done
	  echo 100
	  echo "# Done!"
	) | zenity --width=340 --title "Installing DLLs with Winetricks" --progress --auto-kill

    # mydlls
	elif [ $choice = "My_Dlls_install" ]; then
	mydlls=$(zenity --title "Install custom dlls" --text "paste winetricks (e.g., xna31 d3dx9 xinput faudio)" --entry)
    if [ -z $mydlls ]; #if no dlls are given
       then         
       mydlls=(xact xact_x64 xinput xna31 vcrun2003 vcrun2005 d3dx9 faudio)
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
