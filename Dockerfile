FROM costelabr/runner:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG ATMOSPHERE_TAG=0.19.5

# Get and prebuild parts of Atmosphere
RUN git clone https://github.com/Atmosphere-NX/Atmosphere
WORKDIR /Atmosphere
RUN cd /Atmosphere && \
    git checkout $ATMOSPHERE_TAG && \
    git switch -c deviceid-exosphere

WORKDIR /Atmosphere/exosphere
RUN cd /Atmosphere/exosphere && \
    make -j$(nproc) exosphere.bin && \
    git config --global user.email "fake@name.com" && git config --global user.name Fake Name && git config --global color.ui false

ADD build-deviceid-exosphere.sh .
ADD deviceid.patch .

ENTRYPOINT [ "/Atmosphere/exosphere/build-deviceid-exosphere.sh" ]
