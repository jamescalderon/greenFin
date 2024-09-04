## 1. BUILD ARGS
# These allow changing the produced image by passing different build args to adjust
# the source from which your image is built.
# Build args can be provided on the commandline when building locally with:
#   podman build -f Containerfile --build-arg FEDORA_VERSION=40 -t local-image

# SOURCE_IMAGE arg can be anything from ublue upstream which matches your desired version:
# See list here: https://github.com/orgs/ublue-os/packages?repo_name=main
# - "silverblue"
# - "kinoite"
# - "sericea"
# - "onyx"
# - "lazurite"
# - "vauxite"
# - "base"
#
#  "aurora", "bazzite", "bluefin" or "ucore" may also be used but have different suffixes.
ARG SOURCE_IMAGE="bluefin-dx"

## SOURCE_SUFFIX arg should include a hyphen and the appropriate suffix name
# These examples all work for silverblue/kinoite/sericea/onyx/lazurite/vauxite/base
# - "-main"
# - "-nvidia"
# - "-asus"
# - "-asus-nvidia"
# - "-surface"
# - "-surface-nvidia"
#
# aurora, bazzite and bluefin each have unique suffixes. Please check the specific image.
# ucore has the following possible suffixes
# - stable
# - stable-nvidia
# - stable-zfs
# - stable-nvidia-zfs
# - (and the above with testing rather than stable)
# ARG SOURCE_SUFFIX=""
ARG SOURCE_SUFFIX="-nvidia"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
ARG SOURCE_TAG="gts"

### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
# FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}

# set for the time being to preserve DisplayLink drivers
FROM ghcr.io/jamescalderon/greenfin:20240815 

### 3. MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.
# Install packages and make modifications by executing a script.

# copy files from repo to build
COPY build.sh /tmp/build.sh
# COPY flatpaks.txt /tmp/flatpaks.txt
# COPY extensions.txt /tmp/extensions.txt

# for X-Plane 12, copy over udev rules
COPY flightSim/51-Xsaitekpanels.rules /usr/lib/udev/rules.d 
COPY flightSim/52-HoneycombBravo.rules /usr/lib/udev/rules.d
COPY flightSim/53-saitek-devices.rules /usr/lib/udev/rules.d

# Non-Root Users to Bind to Port 80 (needed for postman)
RUN echo 'net.ipv4.ip_unprivileged_port_start=80' >> /etc/sysctl.conf


# run build
RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit

## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
