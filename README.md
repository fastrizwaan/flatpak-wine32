# flatpaked wine-x86_64 (32 and 64 bit wine using flatpak sandbox)
#### Renamed to wine-x86_64 for readability and typing
Run windows 32bit/64bit games easily.
1. WINEPREFIX=~/.wine-x86_64
2. winetricks also included as gui app, or use CLI to install, e.g., **flatpak run org.winehq.wine-x86_64 winetricks d3dx9 corefonts xinput**
3. commandline **flatpak run org.winehq.wine-x86_64 <exe file>**

####Features
1. Run EXE file from anywhere
2. Create EXE Desktop Shortcut using Right-click 
3. Install d3dx9 xna31 xinput etc. using winetricks 
4. Applications/Games are installed at ~/.wine-x86_64 directory



### Screenshots
#### Application is visible in Menu
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_00.png)
#### .exe files can be opened with Right-Click Open with menu in file manager
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_01.png)

#### wine and winetricks use WINEPREFIX ~/.wine-wine_x86-64
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/wine_02.png)

#### launching wine loads winefile / explorer for easier access to exe files
![](https://github.com/fastrizwaan/flatpak-wine/raw/main/Screenshots/03.png)

##### There are 2 packages:
```
org.winehq.wine-x86-64      - vanilla wine 6.0 inside flatpak. This should do for most 32 bit and 64 bit apps and games
org.winehq.Proton-64-GE-1   - WoW64 proton wine-6.4 can run both 32 and 64 bit
                              
```
```
wget -c https://github.com/fastrizwaan/flatpak-wine/raw/main/org.winehq.Proton-64-GE-1/org.winehq.Proton-64-GE-1.flatpak
flatpak --user install org.winehq.Proton-64-GE-1.flatpak
```

### Also install these Runtime dependencies 
```
sudo flatpak --system remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak update -y
sudo flatpak -y --system install org.freedesktop.Platform/x86_64/20.08 \
                org.freedesktop.Platform.Compat.i386/x86_64/20.08 \
                org.freedesktop.Platform.GL32.default/x86_64/20.08 \
                org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
                org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08
                
NVERSION=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g')				
sudo flatpak install flathub org.freedesktop.Platform.GL32.$NVERSION -y                

```

### Install flatpaks directly and run.
```
wget -c https://github.com/fastrizwaan/flatpak-wine/raw/main/org.winehq.wine-x86-64/org.winehq.wine-x86_64_2021-03-26.flatpak
flatpak --user install org.winehq.wine-x86_64_2021-03-26.flatpak -y

```

#### Test
```
flatpak run org.winehq.wine-x86_64 --version
wine-6.0
```
without any argument/parameters, we launch explorer/winefile so that we could run exe/setup easily
```
flatpak run org.winehq.wine-x86_64
No arguments supplied
launching explorer
```

### Build on your own

#### install SDK for building
```
sudo flatpak --system remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak -y --system install org.freedesktop.Sdk/x86_64/20.08 \
                org.freedesktop.Platform/x86_64/20.08 \
                org.freedesktop.Sdk.Compat.i386 \
                org.freedesktop.Sdk.Extension.toolchain-i386 \
                org.freedesktop.Platform.Compat.i386/x86_64/20.08 \
                org.freedesktop.Platform.GL32.default/x86_64/20.08 \
                org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
                org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08
                
NVERSION=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g')				
sudo flatpak install flathub org.freedesktop.Platform.GL32.$NVERSION -y   
```

#### Build
```
git clone https://github.com/fastrizwaan/flatpak-wine.git
cd flatpak-wine/org.winehq.wine-x86-64/
sh ./install.sh

```

