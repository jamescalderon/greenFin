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

# Chrome native install
echo "[google-chrome]
name=google-chrome - \$ARCH
baseurl=https://dl.google.com/linux/chrome/rpm/stable/$ARCH
enabled=1
gpgcheck=0
gpgkey=https://dl.google.com/linux/linux_signing_key.pub" | sudo tee /etc/yum.repos.d/google-chrome.repo

# - DisplayLink Driver Installation
# DISPLAYLINK_RPM_URL="https://github.com/displaylink-rpm/displaylink-rpm/releases/download/v5.8.0-1/fedora-39-displaylink-1.14.1-2.x86_64.rpm"
# curl -o displaylink.rpm "${DISPLAYLINK_RPM_URL}"

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
rpm-ostree install \
    screen \
    stow \
    firefox \
    chromium \
    thunderbird \
    nautilus-open-any-terminal \
    jetbrains-mono-fonts \
    python3-pip \
    gparted \
    grub-customizer \
    gnome-terminal-nautilus \
    meson

# NVidia GPU installs
rpm-ostree install \
    vulkan-tools \
    vulkan-headers \
    vulkan-validation-layers-devel \
    openal-soft \
    mesa-libGL \
    mesa-libGLU 

    # X-Plane 12 related
rpm-ostree install \
    freeglut \ 
    openal-soft \ 
    libcurl4-openssl-dev 

# commandline switch GPU
rpm-ostree install switcheroo-control 

# from Direct Repo Installs:
rpm-ostree install \
    webapp-manager \
    code-insiders \
    firefoxpwa

rpm-ostree install google-chrome-stable || echo "Failed to install google-chrome-stable"
