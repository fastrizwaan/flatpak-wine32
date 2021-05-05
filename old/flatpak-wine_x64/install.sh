# Install SDK and Runtimes
sudo flatpak -y --system install org.freedesktop.Sdk/x86_64/20.08 \
                org.freedesktop.Platform/x86_64/20.08 \
                org.freedesktop.Sdk.Compat.i386/x86_64/20.08 \
                org.freedesktop.Sdk.Extension.toolchain-i386/x86_64/20.08 \
                org.freedesktop.Platform.Compat.i386/x86_64/20.08 \
                org.freedesktop.Platform.GL32.default/x86_64/20.08 \
				org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
				org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08

NVERSION=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g')				
sudo flatpak install flathub org.freedesktop.Platform.GL32.$NVERSION/x86_64/20.08 -y                   

# Remove old flatpak of this, if installed
rm *.flatpak repo/ -r 2>/dev/null
flatpak remove io.github.flatpak-wine_x64 -y 2>/dev/null

# Build
flatpak-builder --force-clean build-dir io.github.flatpak-wine_x64.yml 

# Create flatpak
flatpak-builder --repo="repo" --force-clean build-dir/ io.github.flatpak-wine_x64.yml 
flatpak --user remote-add --no-gpg-verify "io.github.flatpak-wine_x64" "repo"
flatpak build-bundle "repo" "io.github.flatpak-wine_x64.flatpak" io.github.flatpak-wine_x64 stable --runtime-repo="https://flathub.org/repo/flathub.flatpakrepo"

# Install
flatpak --user install io.github.flatpak-wine_x64.flatpak -y
