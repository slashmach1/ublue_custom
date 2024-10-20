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
ARG SOURCE_IMAGE="kinoite"

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
ARG SOURCE_SUFFIX="-nvidia"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
ARG SOURCE_TAG="latest"

ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}

### 3. MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.
COPY rpms/. /tmp/
COPY setup-hp-wmi.sh /tmp/
COPY hp-set-lighting /tmp/
RUN  rpm-ostree cliwrap install-to-root / && \
    chmod +x /tmp/setup-hp-wmi.sh && \
    /tmp/setup-hp-wmi.sh && \
    chmod +x /tmp/hp-set-lighting && \
    cp /tmp/hp-set-lighting /usr/bin/hp-set-lighting && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /tmp /var/tmp && \
    chmod 1777 /tmp /var/tmp
COPY setup-system.sh /tmp/
RUN  rpm-ostree cliwrap install-to-root / && \
    chmod +x /tmp/setup-system.sh && \
    /tmp/setup-system.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /tmp /var/tmp && \
    chmod 1777 /tmp /var/tmp  
COPY --from=ghcr.io/ublue-os/akmods:main-40 /rpms/kmods/*xpadneo*.rpm /tmp/
COPY --from=ghcr.io/ublue-os/akmods:main-40 /rpms/kmods/*xone*.rpm /tmp/
COPY setup-addons.sh /tmp/
RUN rpm-ostree cliwrap install-to-root / && \
    chmod +x /tmp/setup-addons.sh && \
    /tmp/setup-addons.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /tmp /var/tmp && \
    chmod 1777 /tmp /var/tmp    
COPY setup-configs.sh /tmp/
COPY steam_dev.cfg /tmp/
COPY config/. /tmp/
RUN  rpm-ostree cliwrap install-to-root / && \
    chmod +x /tmp/setup-configs.sh && \
    /tmp/setup-configs.sh && \
    mkdir -vp /usr/src/scripts && \
    cp /tmp/steam_dev.cfg /usr/src/scripts/ && \
    ostree container commit