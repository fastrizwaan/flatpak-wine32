# flatpak-wine: Run wine apps/games with stable 5.0.x
Play 32 and 64 bit wine games from your disk using stable wine inside flatpak.

### Features
1. Run EXE files from File Manager.
2. Create Shortcuts for existing Games/Apps in Menu
3. Kill all Instance shortcut is created to kill all flatpak-wine running processes.
3. Easily Install winetricks dlls
E.g.,
`flatpak run org.winehq.wine-x86_64 winetricks xact xact_x64 xinput xna31 xinput vcrun2005 vcrun2008 corefonts d3dx9 allcodecs`

4. Run in any distro with Flatpak Support
5. Games will not break with wine upgrade by Distro package manager.
6. WINEARCH defaults to win64 bit (both 32bit and 64bit games run)
7. flatpak-wine uses official wine sources, no patches, no nothing
https://dl.winehq.org/wine/source/5.0/

### Requirements:
1. this flatpak (from Releases, see Downloads below)
2. install flatpak dependencies, see Runtime Dependencies below

### Downloads
https://github.com/fastrizwaan/flatpak-wine/releases
```
# for example
flatpak --user install org.winehq.wine-x86_64.flatpak

```

### Runtime dependencies [copy paste the below into gnome-terminal / konsole / XFCE4-Terminal ]
```
sudo flatpak --system remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak update -y
sudo flatpak -y --system install                                       \
                org.freedesktop.Platform/x86_64/20.08                  \
                org.freedesktop.Platform.Compat.i386/x86_64/20.08      \
                org.freedesktop.Platform.GL32.default/x86_64/20.08     \
                org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
                org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08

# For Nvidia GPU users:                
NVERSION=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g')				
sudo flatpak install --system flathub org.freedesktop.Platform.GL.$NVERSION org.freedesktop.Platform.GL32.$NVERSION -y   
```


### Screenshots

#### Application is visible in Menu
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_00.png)
#### .exe files can be opened with Right-Click Open with menu in file manager
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_01.png)

#### wine and winetricks use WINEPREFIX ~/.wine-wine_x86-64
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_02.png)

#### Test
```
flatpak run org.winehq.wine-x86_64 --version
wine-5.0.4
```
without any argument/parameters, we launch explorer++ so that we could run exe/setup easily
```

#### Advanced Usage 
1. Kill running instances, run `flatpak kill org.winehq.wine-x86`
2. To Create win32 arch and install winetricks apps/dlls
```
WINEPREFIX=~/.wine32arch WINEARCH=win32 flatpak run --command=winetricks org.winehq.wine-x86_64  xact xact_x64 dotnet35 xna31 corefonts xinput d3dx9
```

### Build on your own

#### install SDK for building
```
sudo flatpak --system remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak -y --system install                                          \
                org.freedesktop.Sdk/x86_64/20.08                          \
                org.freedesktop.Platform/x86_64/20.08                     \
                org.freedesktop.Sdk.Compat.i386/x86_64/20.08              \
                org.freedesktop.Sdk.Extension.toolchain-i386/x86_64/20.08 \
                org.freedesktop.Platform.Compat.i386/x86_64/20.08         \
                org.freedesktop.Platform.GL32.default/x86_64/20.08        \
                org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08    \
                org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08
```

#### Build
```
cd ../flatpak-wine/org.winehq.wine-x86-64/
sh ./install.sh ; #builds in 1-2 hours as wine is compiled 3 times

# Proton GE 6.4 (works with many games)
git clone https://github.com/fastrizwaan/flatpak-wine.git
cd flatpak-wine/Others/org.winehq.Proton-64-GE-1
sh ./install.sh ; #builds in 10 minutes

```

