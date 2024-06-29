#!/bin/bash

set -ouex pipefail

ARCH=$(uname -m)
echo "ARCHITECTURE = $ARCH"

RELEASE="$(rpm -E %fedora)"
echo "RELEASE = $RELEASE"

### Direct Repo Installs
# - webapp (from Mint)
curl -o /etc/yum.repos.d/refi64-webapp-manager-fedora.repo "https://copr.fedorainfracloud.org/coprs/refi64/webapp-manager/repo/fedora-${RELEASE}/refi64-webapp-manager-fedora-${RELEASE}.repo"

#  - vscode repo
curl -o /etc/yum.repos.d/vscode.repo "https://packages.microsoft.com/yumrepos/vscode/config.repo"

# - Firefox PWA
rpm --import https://packagecloud.io/filips/FirefoxPWA/gpgkey

echo -e "[firefoxpwa]\nname=FirefoxPWA\nmetadata_expire=300\nbaseurl=https://packagecloud.io/filips/FirefoxPWA/rpm_any/rpm_any/\$basearch\ngpgkey=https://packagecloud.io/filips/FirefoxPWA/gpgkey\nrepo_gpgcheck=1\ngpgcheck=0\nenabled=1" | sudo tee /etc/yum.repos.d/firefoxpwa.repo

# Chrome native install (keep getting GPG error?)
# echo "[google-chrome]
# name=google-chrome - \$ARCH
# baseurl=https://dl.google.com/linux/chrome/rpm/stable/$ARCH
# enabled=1
# gpgcheck=1
# gpgkey=https://dl.google.com/linux/linux_signing_key.pub" | sudo tee /etc/yum.repos.d/google-chrome.repo

# Ensure the .gnupg directory exists
sudo mkdir -p /root/.gnupg
sudo chmod 700 /root/.gnupg

curl https://dl.google.com/linux/linux_signing_key.pub | gpg --import
gpg --export --armor 'Google Inc. (Linux Packages Signing Authority) <linux-packages-keymaster@google.com>' > google.asc

rpm-ostree install google-chrome-stable --gpg-import=google.asc || echo "NEW FAILED: google-chrome-stable install"

# - DisplayLink Driver Installation (https://github.com/displaylink-rpm/displaylink-rpm - already included in bluefin?)
# DISPLAYLINK_RPM_URL="https://github.com/displaylink-rpm/displaylink-rpm/releases/download/v5.8.0-1/fedora-39-displaylink-1.14.1-2.x86_64.rpm"
# curl -o displaylink.rpm "${DISPLAYLINK_RPM_URL}"

# Fetch and install openvpn3-client (currently broken)
# copr_owner="dsommers"
# wget https://copr.fedorainfracloud.org/coprs/"${copr_owner}"/openvpn3/repo/fedora-"${RELEASE}"/"${copr_owner}"-openvpn3-fedora-"${RELEASE}".repo -O /etc/yum.repos.d/openvpn3-fedora.repo &&
#   rpm-ostree install openvpn3-client || echo "Installation ${copr_owner}-openvpn3-fedora-${RELEASE} failed - issue retrieving repo"

## Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# General tools and utilities
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
rpm-ostree install meson

# NVidia GPU related packages
rpm-ostree install vulkan-tools
rpm-ostree install vulkan-headers
rpm-ostree install vulkan-validation-layers-devel
rpm-ostree install mesa-libGL
rpm-ostree install mesa-libGLU

# X-Plane 12 related packages
rpm-ostree install freeglut
rpm-ostree install openal-soft
rpm-ostree install libcurl
rpm-ostree install libcurl-devel
rpm-ostree install switcheroo-control
rpm-ostree install gtk3
rpm-ostree install libglvnd-glx

# Direct Repo Installs
rpm-ostree install webapp-manager
rpm-ostree install code-insiders
rpm-ostree install firefoxpwa
# rpm-ostree install google-chrome-stable || echo "FAILED: google-chrome-stable install"
