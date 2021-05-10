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

echo "Starting flatpak build  [x]"

# we are using DATE as branch
DATE=$(date +'%Y%m%d')
WINE_VERSION="6.8"
WINE_SOURCE_URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/6.8-GE-1/Proton-6.8-GE-1.tar.gz"
WINE_SOURCE_SUM="9bc67cb004b72237bfaf15b75b07320d1c2e24ade6b74d881b99881c5a69c084ab0c22a097e3af8dae2c4be5cf37933726f3bb58afd898044f03e576fa020407"
APP_ID="flatpak-proton-68-ge-1"
TAG_NAME="Proton"

# Using template create flatpak-builder flatpak manifest
cp flatpak-wine-template.yml org.winehq.$APP_ID.yml

sed "s/BRANCH/$WINE_VERSION-$DATE/g"       -i org.winehq.$APP_ID.yml
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i org.winehq.$APP_ID.yml
sed "s#WINE_SOURCE_URL#$WINE_SOURCE_URL#g" -i org.winehq.$APP_ID.yml
sed "s/WINE_SOURCE_SUM/$WINE_SOURCE_SUM/g" -i org.winehq.$APP_ID.yml
sed "s/APP_ID/$APP_ID/g"                   -i org.winehq.$APP_ID.yml

# Scripts and desktop file update wine version
cp assets/flatpak-wine-gui.sh.template        assets/$APP_ID-gui.sh
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i assets/$APP_ID-gui.sh
sed "s/APP_ID/$APP_ID/g"                   -i assets/$APP_ID-gui.sh

cp assets/org.winehq.flatpak-wine.desktop.template assets/org.winehq.$APP_ID.desktop
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i assets/org.winehq.$APP_ID.desktop
sed "s/APP_ID/$APP_ID/g"                   -i assets/org.winehq.$APP_ID.desktop


cp assets/wine-create-bottle.sh.template      assets/wine-create-bottle.sh
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i assets/wine-create-bottle.sh
sed "s/APP_ID/$APP_ID/g"                   -i assets/wine-create-bottle.sh
sed "s/TAG_NAME/$TAG_NAME/g"                 -i assets/wine-create-bottle.sh

cp assets/flatpak-wine.sh.template            assets/$APP_ID.sh
sed "s/WINE_VERSION/$WINE_VERSION/g"       -i assets/$APP_ID.sh
sed "s/APP_ID/$APP_ID/g"                   -i assets/$APP_ID.sh

# Icon
cp assets/flatpak-wine.svg  assets/$APP_ID.svg

# Build
flatpak-builder --force-clean build-dir org.winehq.$APP_ID.yml && \
flatpak remove org.winehq.$APP_ID -y && echo "Removed old flatpak     [x]"


# Create flatpak
echo "Creating flatpak repo   [x]"
flatpak-builder --repo="repo" --force-clean build-dir/ org.winehq.$APP_ID.yml 


echo "Installing flatpak-wine [x]"
flatpak-builder --user --install --force-clean build-dir/ org.winehq.$APP_ID.yml 

echo "Creating flatpak bundle [x]"
flatpak build-bundle "repo" "org.winehq.$APP_ID-$WINE_VERSION-$DATE.flatpak" org.winehq.$APP_ID $WINE_VERSION-$DATE

if [ "$1" == "install" ]; then
echo "Installing flatpak-wine flatpak [x]"
# Install
flatpak --user install "org.winehq.$APP_ID-$WINE_VERSION-$DATE.flatpak" -y
fi
echo "Congratulations!!! [x]"
