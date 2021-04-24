# Install SDK and Runtimes

if [ "$1" == "sdk" ]; then
echo -n "Installing SDKs for build "
    sudo flatpak update -y
    sudo flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak -y --user install flathub \
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
#flatpak remove org.winehq.flatpak-wine67 -y 2>/dev/null

echo "Starting flatpak build  [x]"

# Build
flatpak-builder --force-clean build-dir org.winehq.flatpak-wine67.yml && \
flatpak remove org.winehq.flatpak-wine67 -y && echo "Removed old flatpak     [x]"


# Create flatpak
echo "Creating flatpak repo   [x]"
flatpak-builder --repo="repo" --force-clean build-dir/ org.winehq.flatpak-wine67.yml 

echo "Installing flatpak-wine67 [x]"
flatpak-builder --user --install --force-clean build-dir/ org.winehq.flatpak-wine67.yml 
echo "Creating flatpak bundle [x]"
flatpak --user remote-add --no-gpg-verify "org.winehq.flatpak-wine67" "repo" 2>/dev/null
#flatpak build-bundle "repo" "org.winehq.flatpak-wine67_$date.flatpak" org.winehq.flatpak-wine67 stable --runtime-repo="https://flathub.org/repo/flathub.flatpakrepo"
flatpak build-bundle "repo" "org.winehq.flatpak-wine67.flatpak" org.winehq.flatpak-wine67 stable

echo "Installing flatpak-wine67 [x]"
# Install
flatpak --user install org.winehq.flatpak-wine67.flatpak -y

echo "Congratulations!!! [x]"
