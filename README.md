# flatpak-wine: Wine 5.0.x Vanilla and Proton-6.4-GE-1 inside flatpak apps
Most games work with 5.0.4 and rest will run with Proton. So, install both.

## Play 32 and 64 bit wine games from your disk using wine inside flatpak
### Only Requirements is flathub and its runtimes

Run windows 32bit/64bit games easily.
1. uses WINEPREFIX=\~/.Proton-64-GE-1 and WINEPREFIX=\~/.wine-x86_64
2. winetricks also included as gui app, or use CLI to install, e.g., **flatpak run org.winehq.wine-x86_64 winetricks d3dx9 xna31 allcodecs corefonts xinput**
3. commandline **flatpak run org.winehq.wine-x86_64 <exe file>**

#### Features
1. Run EXE file from anywhere in the filesystem
2. Create EXE Desktop Shortcut using Right-click from anywhere in the filesystem
3. Killall Proton-64-GE-1 shortcut is created, to kill running instances, run `flatpak kill org.winehq.wine-x86; flatpak kill org.winehq.Proton-64-GE-1`
4. Install d3dx9 xna31 xinput etc. using winetricks 
5. WINEARCH defaults to win64 bit 
6. to Create win32 arch and install winetricks apps/dlls
```
WINEPREFIX=~/.wine32arch WINEARCH=win32 flatpak run --command=winetricks org.winehq.Proton-64-GE-1 dotnet35 xna31 corefonts xinput d3dx9
WINEPREFIX=~/.wine32arch WINEARCH=win32 flatpak run --command=wine org.winehq.Proton-64-GE-1 <exe> ; to run a program
```

##### There are 2 packages:
```
org.winehq.wine-x86-64      - vanilla wine 5.0.4 inside flatpak. This should do for most 32 bit and 64 bit apps and games
                              (https://dl.winehq.org/wine/source/5.0/)
org.winehq.Proton-64-GE-1   - WoW64 proton wine-6.4 can run both 32 and 64 bit
                              (https://github.com/GloriousEggroll/proton-ge-custom/releases)

```
### Downloads
https://github.com/fastrizwaan/flatpak-wine/releases
```
# for example
flatpak --user install org.winehq.wine-x86_64.flatpak

```

### Also install these Runtime dependencies 
```
sudo flatpak --system remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak update -y
sudo flatpak -y --system install                                       \
                org.freedesktop.Platform/x86_64/20.08                  \
                org.freedesktop.Platform.Compat.i386/x86_64/20.08      \
                org.freedesktop.Platform.GL32.default/x86_64/20.08     \
                org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
                org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08
                
NVERSION=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g')				
sudo flatpak install --system flathub org.freedesktop.Platform.GL.$NVERSION org.freedesktop.Platform.GL32.$NVERSION -y   
```


### Screenshots
##### Select filetype: *.exe and open the program you want to run
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/proton_01.png)
#### Application is visible in Menu
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_00.png)
#### .exe files can be opened with Right-Click Open with menu in file manager
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_01.png)

#### wine and winetricks use WINEPREFIX ~/.wine-wine_x86-64
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_02.png)

#### Test
```
flatpak run org.winehq.Proton-64-GE-1 --version
wine-6.4
flatpak run org.winehq.wine-x86_64 --version
wine-5.0.4
```
without any argument/parameters, we launch explorer++ so that we could run exe/setup easily
```
flatpak run org.winehq.Proton-64-GE-1
(or)
flatpak run org.winehq.wine-x86_64

No arguments supplied
launching explorer
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

                
NVERSION=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g')				
sudo flatpak install --system flathub org.freedesktop.Platform.GL.$NVERSION org.freedesktop.Platform.GL32.$NVERSION -y   
```

#### Build
```
git clone https://github.com/fastrizwaan/flatpak-wine.git
cd flatpak-wine/org.winehq.Proton-64-GE-1
sh ./install.sh ; #builds in 10 minutes

cd ../flatpak-wine/org.winehq.wine-x86-64/
sh ./install.sh ; #builds in 1-2 hours as wine is compiled 3 times

```

