# -----------------------------------------------------------------
#
#    NAME
#      PowerMaster+ Docker File
#
#    DESCRIPTION
#      PowerMaster+ Docker File
#
#    AUTHOR:
#      rcitton@gmail.com 
#
#    NOTES
#
#    MODIFIED   (MM/DD/YY)
#    rcitton     03/02/24 - creation
#
# -----------------------------------------------------------------

# Pull base image
# ---------------
FROM debian:bullseye-slim

#
# Argument Variables
# ---------------------
ARG PMASTERP_URL
ENV DEBIAN_FRONTEND noninteractive


# Maintainer
# ----------
MAINTAINER Ruggero Citton <rcitton@gmail.com>


# Setup Listening Ports
#----------------------
EXPOSE 3052/tcp
EXPOSE 3052/udp
EXPOSE 53568/tcp
EXPOSE 162/udp
EXPOSE 53566/udp


# Setup workdir
#--------------
WORKDIR /opt/pmasterp


# Install dependencies
#---------------------
RUN apt update && apt install -y apt-utils curl unzip procps libusb-1.0-0 usbutils


# Download PowerMaster
#---------------------
RUN curl -s $PMASTERP_URL --output pmasterp_linux64.zip 


# Add files from repository
#--------------------------
COPY response.varfile .
COPY start.sh .


# Set prompt & hostname
RUN echo 'export PS1="[⚡ \e[0;34m\h\e[0m \w]# "' >> /root/.bashrc && \
    echo "pmasterp" > /etc/hostname


# Start Command
#--------------
CMD ["/bin/bash","/opt/pmasterp/start.sh"]





