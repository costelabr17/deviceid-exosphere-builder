FROM costelabr/runner:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG ATMOSPHERE_TAG=0.19.5

# Add our cleanup script
ADD cleanup-repo.sh .
# Give it execution permition and call it
RUN chmod +x cleanup-repo.sh && \
    ./cleanup-repo.sh

# Get and prebuild parts of Atmosphere
RUN git clone https://github.com/Atmosphere-NX/Atmosphere && \
    apt-get update && \
    apt-get install git -y && \
    apt-get upgrade -y 
WORKDIR /Atmosphere
RUN git remote update && \
    git fetch && \
    git checkout $ATMOSPHERE_TAG && \
    git switch deviceid-exosphere

WORKDIR /Atmosphere/exosphere
RUN make -j$(nproc) exosphere.bin && \
    git config --global user.email "fake@name.com" && git config --global user.name Fake Name && git config --global color.ui false

ADD build-deviceid-exosphere.sh .
ADD deviceid.patch .

ENTRYPOINT [ "/Atmosphere/exosphere/build-deviceid-exosphere.sh" ]
