# Run wine 32bit apps using flatpak in Centos 7 or any distro with flatpak support:
```
wget https://github.com/fastrizwaan/flatpak-wine32/raw/main/io.github.flatpak-wine32.flatpak
sha256sum io.github.flatpak-wine32.flatpak ; #check sum below

flatpak --user install io.github.flatpak-wine32.flatpak -y

flatpak run io.github.flatpak-wine32 game.exe ; #replace game.exe with your exe
```
By Default, all programs are installed in ~/.wine, use ` WINEPREFIX=~/.mywine flatpak run io.github.flatpak-wine32 Setup.exe ` to install in ` ~/.mywine ` directory.

### sha256sum io.github.flatpak-wine32.flatpak
```
acea31fb709f601d6ff5dde6929beec12d012edf9adeb084dfce9da77555fcc7  io.github.flatpak-wine32.flatpak

```


# winetricks
### Two ways to run wintricks in flatpak-wine32
#### 1. run from flatpak
```
flatpak run --command=bash io.github.flatpak-wine32
winetricks <whatever>
```
#### 2. run directly from shell
```
flatpak run --command=winetricks io.github.flatpak-wine32 ; #for winetricks GUI

flatpak run --command=winetricks io.github.flatpak-wine32 d3dx9; #for winetricks directx
flatpak run --command=winetricks io.github.flatpak-wine32 xna31; #for winetricks xna framework
flatpak run --command=winetricks io.github.flatpak-wine32 xinput; #for winetricks xinput xbox joystick support
flatpak run --command=winetricks io.github.flatpak-wine32 vcrun2008; #for winetricks vcruntime

```

# flatpak-wine32
wine build with runtime 20.08 i386, provides wine to Centos like distros

a big thanks to https://github.com/Pobega for making his fightcade flatpak manifest with i386 compat

```
sudo flatpak install \
runtime/org.freedesktop.Sdk/x86_64/20.08                           \
org.freedesktop.Platform/x86_64/20.08                              \
runtime/org.freedesktop.Sdk.Compat.i386/x86_64/20.08               \
runtime/org.freedesktop.Sdk.Extension.toolchain-i386/x86_64/20.08  \
org.freedesktop.Platform.GL.default/x86_64/20.08                   \
org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08                  \
org.freedesktop.Platform.openh264/x86_64/2.0                       \
runtime/org.freedesktop.Platform.Compat.i386/x86_64/20.08          \
org.freedesktop.Platform.GL32.default/x86_64/20.08

#flatpak install flathub org.freedesktop.Platform.Compat.i386/x86_64/20.08 org.freedesktop.Platform.GL32.default/x86_64/20.08

flatpak-builder --force-clean build-dir/ io.github.flatpak-wine32.yml
flatpak-builder --install --user --force-clean build-dir/ io.github.flatpak-wine32.yml 
```

Download example installer:
` wget https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.9.3/npp.7.9.3.Installer.exe `

## Usage (install/run windows exe software)
### 1. From inside Flatpak:
```
flatpak run --command=bash io.github.flatpak-wine32
which wine
wine ~/Downloads/npp.7.9.3.Installer.exe
```
### install notepadpp 32 bit installer from inside flatpak runtime
`WINEPREFIX=~/.wine-npp wine ~/Downloads/npp.7.9.3.Installer.exe`


### 2. As commandline Argument to Flatpak 

` flatpak run io.github.flatpak-wine32  ~/Downloads/npp.7.9.3.Installer.exe `

### to install in a separate wine prefix (here replace .TTT with your own)

` WINEPREFIX=~/.TTT flatpak run io.github.flatpak-wine32 ~/Downloads/npp.7.9.3.Installer.exe `

#### 3. Alias it for convenience:


```
alias wine32="flatpak run io.github.flatpak-wine32"
echo 'alias wine32="flatpak run io.github.flatpak-wine32"' >> ~/.bash_aliases
```
### with the alias command

` WINEPREFIX=~/.notepadpp wine32 ~/Downloads/npp.7.9.3.Installer.exe `


## Create flatpak

```
flatpak-builder --repo="repo" --force-clean build-dir/ io.github.flatpak-wine32.yml 
flatpak --user remote-add --no-gpg-verify "io.github.flatpak-wine32" "repo"
flatpak build-bundle "repo" "io.github.flatpak-wine32.flatpak" io.github.flatpak-wine32 --runtime-repo="https://flathub.org/repo/flathub.flatpakrepo"
```

## Install flatpak
` flatpak install --user io.github.flatpak-wine32.flatpak `


## For Nvidia Users, install your version of Nvidia drivers
```
flatpak remote-ls flathub | grep nvidia

#flatpak install flathub org.freedesktop.Platform.GL32.nvidia-MAJORVERSION-MINORVERSION
flatpak install flathub org.freedesktop.Platform.GL32.nvidia-460-39
#or
flatpak install flathub org.freedesktop.Platform.GL32
```
