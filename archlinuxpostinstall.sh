#!/bin/bash
echo "Setting up Arch Linux for gaming, streaming, coding, office work, and multimedia..."

# Update system
sudo pacman -Syu

# Install Yay
sudo pacman -S yay --needed --noconfirm

# Install AMD GPU drivers
sudo pacman -S xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon mesa lib32-mesa

# Install Steam, Proton, and additional gaming tools
yay -S steam proton lutris wine mangohud gamemode power-profiles-daemon

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
sudo pacman -S git nodejs npm
yay -S react-native-cli android-studio
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

# Install multimedia software (Spotify and VLC)
yay -S spotify vlc

# Install Visual Studio Code, Firefox, and Chromium
yay -S visual-studio-code-bin firefox chromium

# Install text editors for terminal
sudo pacman -S vim nano

# Install Hyprland
yay -S hyprland-git
git clone https://github.com/JaKooLit/Arch-Hyprland.git
cd Arch-Hyprland
chmod +x install.sh
./install.sh

# Install and configure desktop environment (optional)
sudo pacman -S sddm
sudo systemctl enable sddm

# Clean up Yay cache
yay -Sc --noconfirm

echo "Setup complete! Reboot your system to apply all changes."
