ARG DEBIAN_FRONTEND=noninteractive
ARG ATMOSPHERE_TAG=0.19.5

FROM costelabr/runner:latest

ARG DEBIAN_FRONTEND
ARG ATMOSPHERE_TAG

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
