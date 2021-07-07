FROM devkitpro/devkita64:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG ATMOSPHERE_TAG=0.19.5
ARG DEBIAN_FRONTEND
ARG DEVKITPRO_URL
ARG DEVKITPRO_FILE
ARG ATMOSPHERE_TAG

# Install base libs
RUN apt update && \
    apt install -y \
    wget \
    git \
    build-essential \
    libxml2 \
    libxml2-dev \
    libxml2-utils \
    zip \
    curl \
    libarchive13 \
    pkg-config \
    libglm-dev \
    python3 \
    python3-pip

RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN pip3 install pycryptodome lz4

RUN dkp-pacman -S --noconfirm switch-dev switch-libjpeg-turbo devkitARM devkitarm-rules

# Get and prebuild parts of Atmosphere
RUN git clone https://github.com/Atmosphere-NX/Atmosphere
WORKDIR /Atmosphere
RUN git checkout $ATMOSPHERE_TAG
RUN git switch -c deviceid-exosphere
WORKDIR /Atmosphere/exosphere
RUN make -j$(nproc) exosphere.bin

RUN git config --global user.email "fake@name.com" && git config --global user.name Fake Name && git config --global color.ui false

ADD build-deviceid-exosphere.sh .
ADD deviceid.patch .

ENTRYPOINT [ "/Atmosphere/exosphere/build-deviceid-exosphere.sh" ]
