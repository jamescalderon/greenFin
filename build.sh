#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

echo "RELEASE = $RELEASE"

# echo "USER = $USER"

### COPRs
# - webapp (from Mint)
curl -o /etc/yum.repos.d/refi64-webapp-manager-fedora.repo "https://copr.fedorainfracloud.org/coprs/refi64/webapp-manager/repo/fedora-${RELEASE}/refi64-webapp-manager-fedora-${RELEASE}.repo"

#  - vscode repo
curl -o /etc/yum.repos.d/vscode.repo "https://packages.microsoft.com/yumrepos/vscode/config.repo"

# - Firefox PWA
rpm --import https://packagecloud.io/filips/FirefoxPWA/gpgkey

echo -e "[firefoxpwa]\nname=FirefoxPWA\nmetadata_expire=300\nbaseurl=https://packagecloud.io/filips/FirefoxPWA/rpm_any/rpm_any/\$basearch\ngpgkey=https://packagecloud.io/filips/FirefoxPWA/gpgkey\nrepo_gpgcheck=1\ngpgcheck=0\nenabled=1" | sudo tee /etc/yum.repos.d/firefoxpwa.repo


# - DisplayLink Driver Installation
# DISPLAYLINK_RPM_URL="https://github.com/displaylink-rpm/displaylink-rpm/releases/download/v5.8.0-1/fedora-39-displaylink-1.14.1-2.x86_64.rpm"        
# curl -o displaylink.rpm "${DISPLAYLINK_RPM_URL}"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
rpm-ostree install screen
rpm-ostree install stow
rpm-ostree install firefox
rpm-ostree install chromium
rpm-ostree install thunderbird
rpm-ostree install nautilus-open-any-terminal
rpm-ostree install jetbrains-mono-fonts
rpm-ostree install python3-pip
rpm-ostree install gparted
rpm-ostree install grub-customizer
rpm-ostree install gnome-terminal-nautilus

# x-plane-specific dependencies
rpm-ostree install vulkan-tools
rpm-ostree install meson
rpm-ostree install vulkan-headers
rpm-ostree install vulkan-validation-layers-devel
rpm-ostree install openal-soft
rpm-ostree install mesa-libGL
rpm-ostree install mesa-libGLU

# meson builddir --prefix=/usr
# meson compile -C builddir
# sudo meson install -C builddir

# rpm-ostree install 

# from COPRs:
rpm-ostree install webapp-manager
rpm-ostree install code-insiders
rpm-ostree install firefoxpwa

# Chrome native install
# Part of an attempt to add Google Chrome in the usual way.
echo "Fixing google-chrome yum repo"
sed -i '/enabled/d' /etc/yum.repos.d/google-chrome.repo 
echo "enabled=1" >> /etc/yum.repos.d/google-chrome.repo

echo "Downloading Google Signing Key"
curl https://dl.google.com/linux/linux_signing_key.pub > /tmp/linux_signing_key.pub

rpm --import /tmp/linux_signing_key.pub

# install flatpaks
# xargs flatpak install -y < /tmp/flatpaks.txt

# install gnome extensions
# pip install --upgrade gnome-extensions-cli

# EXTENSIONS_FILE="/tmp/extensions.txt"

# while IFS= read -r extension; do
#   gext install "$extension"
# done < "$EXTENSIONS_FILE"

# rpm-ostree install displaylink.rpm
# rm displaylink.rpm

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

# systemctl enable podman.socket
