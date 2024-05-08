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

# copy files from repo to build
COPY build.sh /tmp/build.sh
COPY flatpaks.txt /tmp/flatpaks.txt
COPY extensions.txt /tmp/extensions.txt

# run build
RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit

# Note: /var/lib/alternatives is needed to avoid RPM install failures. All RUN commands must end with 'ostree container commit'.

