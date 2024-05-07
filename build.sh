#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

echo "RELEASE = $RELEASE"

### COPRs
curl -o /etc/yum.repos.d/refi64-webapp-manager-fedora.repo "https://copr.fedorainfracloud.org/coprs/refi64/webapp-manager/repo/fedora-${RELEASE}/refi64-webapp-manager-fedora-${RELEASE}.repo"

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


# from COPRs:
# rpm-ostree install firefoxpwa
# rpm-ostree install webapp-manager

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

# systemctl enable podman.socket
