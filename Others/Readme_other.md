# Flatpak Wine (5.0.5)

Copyright: (C) GNU GPL3 Mohammed Asif Ali Rizvan 
Email    : fast.rizwaan@gmail.com
Github   : github.com/fastrizwaan

### For the impatient
In a terminal window, copy paste these:

```
#Install flathub repo and dependencies for flatpak-wine
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak -y --user install flathub                              \
        org.freedesktop.Platform/x86_64/20.08                  \
        org.freedesktop.Platform.Compat.i386/x86_64/20.08      \
        org.freedesktop.Platform.GL32.default/x86_64/20.08     \
        org.freedesktop.Platform.GL.default/x86_64/20.08       \
        org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
        org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08      \
        org.freedesktop.Platform.ffmpeg_full/x86_64/20.08      \
        org.freedesktop.Platform.ffmpeg_full.i386/x86_64/20.08    

#for Nvidia users
if [ -f /proc/driver/nvidia/version ]; then
    ver=$(grep -Eo '[0-9][0-9][0-9].[0-9][0-9]*' /proc/driver/nvidia/version|tr '.' '-')
    flatpak -y --user install flathub                 \
        org.freedesktop.Platform.GL.nvidia-$ver   \
        org.freedesktop.Platform.GL32.nvidia-$ver
fi

#Install flatpak-wine bundle
wget -c https://github.com/fastrizwaan/flatpak-wine/releases/download/5.0.5r2/org.winehq.flatpak-wine.flatpak
flatpak -y --user install org.winehq.flatpak-wine.flatpak
```


## What is flatpak wine?
### =====================
Flatpak-wine is simply wine and winetricks bundled in a flatpak file. 
To make working with wine prefixes (or bottles), it includes bash scripts.
These bash scripts can be used for:
    default bottle 
    Game/app bottle (~/.local/share/flatpak-wine/bottles/game.exe/)

It is not sandboxed or limited to few directories because, we need to access apps/games in different partitions or directories. But everything is official, there are no patches. 


Default bottle:
---------------
whatever we install/run using terminal `flatpak run org.winehq.flatpak-wine` or (open-with from file manager) `flatpak-wine (5.0.5)` or from menu goes to the wineprefix: `~/.local/share/flatpak-wine/default` directory. This can be used to test/install softwares/games. The default bottle / wine prefix gets messed up by installing many apps/games or winetricks dlls. A "delete bottle" option is provided to delete `~/.local/share/flatpak-wine/default`. 

Game.exe / app.exe bottles:
---------------------------
It would be good if we create and use separate bottles for each of our games/apps. And for that we can create game or app specific bottle. To do that right-click on an .exe file in the file manager (nautilus / dolphin / thunar) and choose "Create Bottle using flatpak-wine" from right-click menu of filemanager. It will ask for a name, if no name is given, "filename.exe" is used in the menu. 

The game/app bottle creates a wineprefix and a launch script for that game/app at `~/.local/share/flatpak-wine/bottles/` and creates a shortcut at the Game/App directory which is symbolically linked (ln -s) to `~/.local/share/applications/flatpak-wine/`


Customizing Bottles:
--------------------
Both default and app/game specific bottles provide some options to customize, like winetricks gui, winecfg etc. We can open flatpak sandbox shell from the options, and run winetricks, wine like we run from terminal window.

customzing flatpak-wine or game bottle with winetricks:
-------------------------------------------------------
Install your required dlls using winetricks 


Commandline using terminal window:
==================================
Default bottle:
---------------
`flatpak run org.winehq.wine-x86_64 winetricks xact xact_x64 xinput xna31 xinput vcrun2005 vcrun2008 corefonts d3dx9 d9vk faudio`

Game/App bottle:
----------------
`~/.local/share/flatpak-wine/bottles/game.exe.sh winetricks xact xact_x64 xinput xna31 xinput vcrun2005 vcrun2008 corefonts d3dx9 d9vk faudio`

see your created bottles by `ls ~/.local/share/flatpak-wine/`

How to access this app/wine bottle
----------------------------------
In your desktop environment, from the menu (Game or Others submenu or which you chose while creating bottle) or via command line, "~/.local/share/flatpak-wine/bottles/game.exe.sh". To check all available bottles: `ls ~/.local/share/flatpak-wine/bottles/*.sh`


Why flatpak-wine when others (lutris, playonlinux, bottles, etc.) exist?
========================================================================
Lutris, Bottles, Phoenicis, PlayOnLinux, either does not work consistently and or have confusing frontend / interface. 
Flatpak-wine is trying to be simple, and work as expected i.e., running exe from filemanager, and creating bottles from exe is easier in flatpak-wine.


Why wine inside flatpak?
========================
1. Upgrade breakage fix: Apps and games which work fine, will not be broken with distribution upgrades.
2. Consistent Version  : wine within flatpak with a fixed version (5.0.x) works across all flatpak supported distributions (https://flatpak.org/setup/). 
3. Availability        : Centos like distributions do not provide 32 bit wine in their repository. 
he advantage is that the shared libraries are consistent across all distributions.  which can be used to run  official wine build from winehq.
4. Consistent libraries: wine in different distro may not work because of missing libraries, e.g., debian needs to enable 32 bit support.
5. Works like wine bottle management apps like PlayOnLinux / Lutris for wine / Bottles app.
6. Straight forward and quick launching of Windows programs and games.


Why wine 5.0.x why not 6.x?
===========================
Because it is difficult to manage many versions. Some games work nicely with 5.0.5 like Raji: An Ancient Tale. There's also flatpak-wine66 (wine 6.6) if you want to try. And flatpak-proton64 (Proton 6.4 GE 1 works than 65) which runs Crash Bandicoot 4: It's about time fully (videos play). See Releases. And for older games like "The Elder Scrolls III: Morrowind", there's flatpak-wine217 (wine 2.17 32 bit only)


Can we make a flatpak bundle of Game + wine?
============================================
Yes, for that see winepak-x86_64 (https://github.com/fastrizwaan/winepak-x86_64). 
The Drawback of winepak-x86_64 bundle is that creating bundle takes a lot of time 20 minutes to hours. and it is difficult to bundle all the runtime stuff for all the games. Some games and apps can be bundled easily with that. Bottles created with flatpak-wine is a simple solution.


Usage (commandline):
====================
flatpak run org.winehq.flatpak-wine --version
wine-5.0.5
flatpak run org.winehq.flatpak-wine --help


How to kill/stop stuck flatpak-wine game or application?
========================================================
from the terminal window run `flatpak kill org.winehq.flatpak-wine` or from your desktop environment's menu select "kill flatpak-wine (5.0.5)"

How to build the same flatpak on my system?
===========================================
It's simple:

```
git clone https://github.com/fastrizwaan/flatpak-wine.git
cd flatpak-wine/org.winehq.flatpak-wine
sh ./install.sh sdk ;# this will install sdk, run this only once sdk
```

this will create a flatpak and also install it (as --user)
