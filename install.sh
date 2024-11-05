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

echo "Installing applications for gaming..."

# Install gaming-related applications
sudo pacman -S steam lutris wine mangohud gamemode

echo "Installing applications for entertainment..."

# Install entertainment-related applications
sudo pacman -S spotify vlc

echo "Installing applications for development..."

# Install development-related applications
sudo pacman -S code vim nano nodejs npm

echo "Installing additional utilities and tools..."

# Install base development tools and utilities
sudo pacman -S base-devel git

# Install Yay for AUR packages
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

echo "Installing office and multimedia applications..."

# Install office and multimedia applications
sudo pacman -S libreoffice-fresh obs-studio power-profiles-daemon

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

echo "Installing Android Studio and setting up environment for React Native..."

# Install Android Studio and setup environment for React Native
yay -S android-studio
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

echo "Installing themes and icons..."

# Install themes and icons
yay -S arc-gtk-theme papirus-icon-theme

echo "Fixing home directory ownership and permissions..."

# Fix home directory ownership and permissions
sudo chown -R $USER:$USER /home/$USER
chmod -R 755 /home/$USER

echo "Fixing screen sharing issues with OBS and Discord..."

# Fix screen sharing issues
sudo pacman -S xorg-server-xvfb
echo 'Xvfb :99 -screen 0 1920x1080x24 &' >> ~/.xprofile

echo "Cleaning up Pacman cache..."

# Clean up Pacman cache
sudo pacman -Sc --noconfirm

echo "Setup complete! Reboot your system to apply all changes."
