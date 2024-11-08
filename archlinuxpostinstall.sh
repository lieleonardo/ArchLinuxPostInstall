#!/bin/bash
echo "Setting up Arch Linux for gaming, streaming, coding, office work, and multimedia..."

# Update system
sudo pacman -Syu

# Install base development tools and utilities
sudo pacman -S base-devel git

# Install Yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

# Install AMD GPU drivers
sudo pacman -S xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon mesa lib32-mesa

# Install VMware display drivers
# sudo pacman -S xf86-video-vmware mesa

# Install Steam, Proton, and additional gaming tools
sudo pacman -S steam lutris wine mangohud gamemode power-profiles-daemon

# Enable Multilib repository if not already enabled
sudo sed -i '/

\[multilib\]

/,/Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
sudo pacman -Syu

# Install OBS Studio for live streaming
sudo pacman -S obs-studio

# Install office suite (LibreOffice)
sudo pacman -S libreoffice-fresh

# Install development tools for coding (including React Native)
sudo pacman -S nodejs npm
sudo npm install -g react-native-cli

# Install Android Studio and setup environment for React Native
yay -S android-studio
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

# Install multimedia software (Spotify and VLC)
sudo pacman -S spotify vlc

# Install Visual Studio Code, Firefox, and Chromium
sudo pacman -S code firefox chromium

# Install text editors for terminal
sudo pacman -S vim nano

# Install KDE Plasma
sudo pacman -S plasma kde-applications

# Install and configure SDDM
sudo pacman -S sddm
sudo systemctl enable sddm

# Install SDDM themes
yay -S sddm-nordic-theme

# Configure SDDM with Nordic theme
sudo bash -c 'cat > /etc/sddm.conf <<EOF
[Theme]
Current=Nordic

[General]
InputMethod=
Numlock=on

[Users]
MaximumUid=60000
MinimumUid=1000
EOF'

# Install themes and icons
yay -S arc-gtk-theme papirus-icon-theme

# Fix home directory ownership and permissions
sudo chown -R $USER:$USER /home/$USER
chmod -R 755 /home/$USER

# Install Discord
yay -S discord

# Fix screen sharing issues with OBS and Discord
echo "Fixing screen sharing issues..."
sudo pacman -S xorg-server-xvfb
echo 'Xvfb :99 -screen 0 1920x1080x24 &' >> ~/.xprofile

# Install KDE themes and customization tools
sudo pacman -S kvantum-qt5

# Install sound packages
sudo pacman -S alsa-utils pulseaudio pulseaudio-alsa pavucontrol

# Enable ALSA service
sudo systemctl enable --now alsa-restore

# Enable PulseAudio services
systemctl --user enable pulseaudio
systemctl --user start pulseaudio

# Clean up Pacman cache
sudo pacman -Sc --noconfirm

echo "Setup complete! Reboot your system to apply all changes."
