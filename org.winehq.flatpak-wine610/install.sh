# Install SDK and Runtimes

if [ "$1" == "sdk" ]; then
echo -n "Installing SDKs for build "
     flatpak update -y
     flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
     flatpak -y --user install flathub \
                    org.freedesktop.Sdk/x86_64/20.08 \
                    org.freedesktop.Platform/x86_64/20.08 \
                    org.freedesktop.Sdk.Compat.i386/x86_64/20.08 \
                    org.freedesktop.Sdk.Extension.toolchain-i386/x86_64/20.08 \
                    org.freedesktop.Platform.Compat.i386/x86_64/20.08 \
                    org.freedesktop.Platform.GL32.default/x86_64/20.08 \
                    org.freedesktop.Platform.GL.default/x86_64/20.08 \
                    org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
                    org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08 \
                    org.freedesktop.Platform.ffmpeg_full.i386/x86_64/20.08 \
                    org.freedesktop.Platform.ffmpeg-full/x86_64/20.08      
                     

    # If nvidia drivers are installed 
    if [ -f /proc/driver/nvidia/version ]; then
        ver=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g')
        flatpak -y --user install flathub    \
            org.freedesktop.Platform.GL.$ver   \
            org.freedesktop.Platform.GL32.$ver
    fi           

fi 
 
# Remove old flatpak of this, if installed

rm *.flatpak repo/ -r 2>/dev/null
echo "Removed old flatpak     [x]"
echo "Removed old repo/ dir   [x]"
#flatpak remove org.winehq.flatpak-wine -y 2>/dev/null

echo "Starting flatpak build  [x]"

# we are using DATE as branch
DATE=$(date +'%Y%m%d')

WINE_VERSION="6.10"
WINE_SOURCE_URL="https://dl.winehq.org/wine/source/6.x/wine-6.10.tar.xz"
WINE_SOURCE_SUM="f0e8f0bdab09c979772965d167d687e88998f3fd6537a592e201a2dc9097552e03b1c413516cc8c82665a8bf17580777f48bd1ed9033641f04e7ef7f0b29cc60"


FLATPAKID=$(echo $WINE_VERSION|sed 's|\.||g')


# Using template create flatpak-builder flatpak manifest
cp flatpak-wine-template.yml org.winehq.flatpak-wine.yml

sed "s/BRANCH/$WINE_VERSION-$DATE/g"       -i org.winehq.flatpak-wine.yml
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i org.winehq.flatpak-wine.yml
sed "s#WINE_SOURCE_URL#$WINE_SOURCE_URL#g" -i org.winehq.flatpak-wine.yml
sed "s/WINE_SOURCE_SUM/$WINE_SOURCE_SUM/g" -i org.winehq.flatpak-wine.yml
sed "s/FLATPAKID/$FLATPAKID/g"             -i org.winehq.flatpak-wine.yml

# Scripts and desktop file update wine version
cp assets/flatpak-wine-gui.sh.template        assets/flatpak-wine-gui.sh
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i assets/flatpak-wine-gui.sh
sed "s/FLATPAKID/$FLATPAKID/g"             -i assets/flatpak-wine-gui.sh

cp assets/wine-create-bottle.sh.template      assets/wine-create-bottle.sh
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i assets/wine-create-bottle.sh
sed "s/FLATPAKID/$FLATPAKID/g"             -i assets/wine-create-bottle.sh

cp assets/flatpak-wine.sh.template            assets/flatpak-wine.sh
sed "s/FLATPAKID/$FLATPAKID/g"             -i assets/flatpak-wine.sh

cp assets/org.winehq.flatpak-wine.desktop.template assets/org.winehq.flatpak-wine$FLATPAKID.desktop
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i assets/org.winehq.flatpak-wine$FLATPAKID.desktop
sed "s/FLATPAKID/$FLATPAKID/g"             -i assets/org.winehq.flatpak-wine$FLATPAKID.desktop

# Build
flatpak-builder --force-clean build-dir org.winehq.flatpak-wine.yml && \
flatpak remove org.winehq.flatpak-wine$FLATPAKID -y && echo "Removed old flatpak     [x]"


# Create flatpak
echo "Creating flatpak repo   [x]"
flatpak-builder --repo="repo" --force-clean build-dir/ org.winehq.flatpak-wine.yml 


echo "Installing flatpak-wine [x]"
flatpak-builder --user --install --force-clean build-dir/ org.winehq.flatpak-wine.yml 

echo "Creating flatpak bundle [x]"
#flatpak --user remote-add --no-gpg-verify "org.winehq.flatpak-wine" "repo" 
#flatpak build-bundle "repo" "org.winehq.flatpak-wine_$date.flatpak" org.winehq.flatpak-wine $WINE_VERSION-$DATE
#--runtime-repo="https://flathub.org/repo/flathub.flatpakrepo"
flatpak build-bundle "repo" "org.winehq.flatpak-wine$FLATPAKID-$WINE_VERSION-$DATE.flatpak" org.winehq.flatpak-wine$FLATPAKID $WINE_VERSION-$DATE

if [ "$1" == "install" ]; then
echo "Installing flatpak-wine flatpak [x]"
# Install
flatpak --user install "org.winehq.flatpak-wine$FLATPAKID-$WINE_VERSION-$DATE.flatpak" -y
fi
echo "Congratulations!!! [x]"
