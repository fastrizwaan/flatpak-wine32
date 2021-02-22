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
org.freedesktop.Platform.openh264/x86_64/2.0                       

flatpak install flathub org.freedesktop.Platform.Compat.i386/x86_64/20.08 org.freedesktop.Platform.GL32.default/x86_64/20.08

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
### Download 32 bit installer
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

```
