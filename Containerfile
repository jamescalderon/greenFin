## 1. BUILD ARGS
# Define the source image with a default value.
ARG SOURCE_IMAGE="bluefin-dx"

# Define the source suffix with a default value.
ARG SOURCE_SUFFIX="-nvidia"

# Define the source tag with a default value.
ARG SOURCE_TAG="gts"

### 2. SOURCE IMAGE
# Use the build arguments to select the right upstream image.
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}

### 3. MODIFICATIONS
# Install packages and make modifications by executing a script.

# Adding Copr repo for webapp-manager owned by refi64
# RUN wget "https://copr.fedorainfracloud.org/coprs/refi64/webapp-manager/repo/fedora-${FEDORA_MAJOR_VERSION}/refi64-webapp-manager-fedora-${FEDORA_MAJOR_VERSION}.repo" -O /etc/yum.repos.d/refi64-webapp-manager-fedora.repo && \
#     ostree container commit

# # Adding Firefox PWA repository
# RUN rpm --import https://packagecloud.io/filips/FirefoxPWA/gpgkey && \
#     echo -e "[firefoxpwa]\nname=FirefoxPWA\nmetadata_expire=300\nbaseurl=https://packagecloud.io/filips/FirefoxPWA/rpm_any/rpm_any/\$basearch\ngpgkey=https://packagecloud.io/filips/FirefoxPWA/gpgkey\nrepo_gpgcheck=1\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/firefoxpwa.repo && \
#     ostree container commit

COPY build.sh /tmp/build.sh

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
# Note: /var/lib/alternatives is needed to avoid RPM install failures. All RUN commands must end with 'ostree container commit'.

