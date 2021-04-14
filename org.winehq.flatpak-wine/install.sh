# Install SDK and Runtimes
sudo flatpak update -y
sudo flatpak --system remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak -y --system install org.freedesktop.Sdk/x86_64/20.08 \
                org.freedesktop.Platform/x86_64/20.08 \
                org.freedesktop.Sdk.Compat.i386/x86_64/20.08 \
                org.freedesktop.Sdk.Extension.toolchain-i386/x86_64/20.08 \
                org.freedesktop.Platform.Compat.i386/x86_64/20.08 \
                org.freedesktop.Platform.GL32.default/x86_64/20.08 \
		org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
		org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08

# If nvidia drivers are installed 
if [ -x /usr/bin/nvidia-settings ]; then 
lsmod |grep -i nvidia && \
NVERSION=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g') && \
sudo flatpak install flathub org.freedesktop.Platform.GL32.$NVERSION/x86_64/20.08 org.freedesktop.Platform.GL32.$NVERSION/x86_64/1.4 -y   
fi                 

# Remove old flatpak of this, if installed
rm *.flatpak repo/ -r 2>/dev/null
#flatpak remove org.winehq.flatpak-wine -y 2>/dev/null


# Build
flatpak-builder --force-clean build-dir org.winehq.flatpak-wine.yml 


# Create flatpak
flatpak-builder --repo="repo" --force-clean build-dir/ org.winehq.flatpak-wine.yml 
flatpak-builder --user --install --force-clean build-dir/ org.winehq.flatpak-wine.yml 
flatpak --user remote-add --no-gpg-verify "org.winehq.flatpak-wine" "repo"
flatpak build-bundle "repo" "org.winehq.flatpak-wine_$date.flatpak" org.winehq.flatpak-wine stable --runtime-repo="https://flathub.org/repo/flathub.flatpakrepo"
#flatpak build-bundle "repo" "org.winehq.flatpak-wine.flatpak" org.winehq.flatpak-wine stable

# Install
flatpak --user install org.winehq.flatpak-wine.flatpak -y
