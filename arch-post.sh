#!/bin/bash

echo "=== Arch Linux Post-Installation Setup ==="

# Update system first
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install essential packages
echo "Installing essential packages..."
sudo pacman -S --needed --noconfirm git base-devel wget curl

# Install yay AUR helper
echo "Installing yay AUR helper..."
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
  cd ..
  rm -rf yay-bin
else
  echo "yay is already installed"
fi

# Hyprland-focused setup
echo "Installing Hyprland and essential Wayland components..."

# Core Hyprland setup
sudo pacman -S --noconfirm \
  hyprland \
  waybar \
  wofi \
  dunst \
  kitty \
  thunar \
  grim \
  slurp \
  wl-clipboard \
  brightnessctl \
  pamixer \
  network-manager-applet \
  blueman \
  polkit-gnome

# Display manager
sudo pacman -S --noconfirm sddm
sudo systemctl enable sddm

# File manager with useful plugins
sudo pacman -S --noconfirm thunar thunar-archive-plugin thunar-volman

# Fonts for better UI
sudo pacman -S --noconfirm \
  ttf-font-awesome \
  ttf-fira-code \
  noto-fonts \
  noto-fonts-emoji

# Wallpaper tools
yay -S --noconfirm swww hyprpaper-git

echo "Installing additional Hyprland utilities..."
yay -S --noconfirm \
  rofi-lbonn-wayland-git \
  waybar-hyprland-git \
  hyprpicker-git \
  hyprshot-git

# Terminal and Browser
echo "Installing terminal and browser..."
yay -S --noconfirm warp-terminal
yay -S --noconfirm zen-browser-bin

# Development tools
echo "Installing development tools..."
sudo pacman -S --noconfirm neovim vim code firefox

# Neovim configuration
read -p "Do you want to install your custom Neovim config? (y/n): " install_nvim_config
if [[ $install_nvim_config =~ ^[Yy]$ ]]; then
  echo "Installing custom Neovim configuration..."
  # Backup existing config if it exists
  if [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
  fi
  git clone https://github.com/rinnegan72/nvim.git ~/.config/nvim
fi

# Audio
echo "Installing audio system..."
sudo pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Enable services
echo "Enabling essential services..."
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

# Install additional useful packages
echo "Installing additional useful packages..."
sudo pacman -S --noconfirm \
  htop \
  tree \
  unzip \
  zip \
  man-db \
  firefox \
  vlc \
  gimp \
  libreoffice-fresh \
  discord \
  steam

echo "=== Installation Complete! ==="
echo "Please reboot your system to ensure all services start properly."
echo "After reboot, you can log into your chosen desktop environment."

read -p "Do you want to reboot now? (y/n): " reboot_now
if [[ $reboot_now =~ ^[Yy]$ ]]; then
  sudo reboot
fi
