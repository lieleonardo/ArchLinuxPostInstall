#!/bin/bash

echo "Updating system first..."
# Update system
sudo pacman -Syu

echo "Select your graphics driver:"
echo "1) AMD"
echo "2) NVIDIA"
echo "3) Intel"
echo "4) VMware"
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        # Install AMD GPU drivers
        sudo pacman -S xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon mesa lib32-mesa
        ;;
    2)
        # Install NVIDIA GPU drivers
        sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils
        ;;
    3)
        # Install Intel GPU drivers
        sudo pacman -S xf86-video-intel mesa lib32-mesa
        ;;
    4)
        # Install VMware display drivers
        sudo pacman -S xf86-video-vmware mesa
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo "Freeing up disk space before installing SDDM theme..."
# Remove unnecessary packages
sudo pacman -Rns $(pacman -Qtdq)
# Clean up the package cache
sudo pacman -Sc --noconfirm
# Remove any large, unnecessary files
sudo rm -rf /var/cache/pacman/pkg/*

# Install and configure SDDM
sudo pacman -S sddm
sudo systemctl enable sddm

# Install wget and unzip for downloading and extracting themes
sudo pacman -S wget unzip

# Create directory for Nord theme
mkdir -p ~/Downloads/nord-sddm

# Download and install Nord theme for SDDM
wget -O ~/Downloads/nord-sddm/master.zip https://github.com/nautilor/nord-sddm/archive/refs/heads/master.zip
unzip ~/Downloads/nord-sddm/master.zip -d ~/Downloads/nord-sddm
sudo cp -R ~/Downloads/nord-sddm/nord-sddm-master/* /usr/share/sddm/themes/

# Create SDDM configuration directory if it doesn't exist
sudo mkdir -p /etc/sddm.conf.d/

# Configure SDDM to use the Nord theme
sudo bash -c 'cat > /etc/sddm.conf.d/custom.conf <<EOF
[Theme]
Current=Nord
EOF'

echo "Continuing setup for gaming, streaming, coding, office work, and multimedia..."

# Install base development tools and utilities
sudo pacman -S base-devel git

# Install Yay for AUR packages
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

# Install essential applications for your needs
sudo pacman -S steam lutris wine mangohud gamemode power-profiles-daemon obs-studio libreoffice-fresh nodejs npm code firefox chromium vim nano kvantum-qt5 spotify vlc

# Install Discord
yay -S discord

# Prompt to install audio packages
read -p "Do you want to install audio packages? (y/n): " install_audio

if [[ $install_audio == "y" || $install_audio == "Y" ]]; then
    sudo pacman -S alsa-utils pulseaudio pulseaudio-alsa pavucontrol
    sudo systemctl enable --now alsa-restore
    systemctl --user enable pulseaudio
    systemctl --user start pulseaudio
    echo "Audio packages installed and services enabled."
else
    echo "Skipping audio package installation."
fi

# Install Android Studio and setup environment for React Native
yay -S android-studio
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

# Install themes and icons
yay -S arc-gtk-theme papirus-icon-theme

# Fix home directory ownership and permissions
sudo chown -R $USER:$USER /home/$USER
chmod -R 755 /home/$USER

# Fix screen sharing issues with OBS and Discord
echo "Fixing screen sharing issues..."
sudo pacman -S xorg-server-xvfb
echo 'Xvfb :99 -screen 0 1920x1080x24 &' >> ~/.xprofile

# Clean up Pacman cache
sudo pacman -Sc --noconfirm

echo "Setup complete! Reboot your system to apply all changes."
