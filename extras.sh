#!/usr/bin/env bash

#if [ ! "$SLIMV_BOX_OPTIONALPKGS" = "1" ]
#then
#    echo skipping optional packages
#    exit 0
#fi

## for CEPL without hardware acceleration
apt-get update && apt-get install -y \
libglapi-mesa \
libgl1-mesa-dev \
libsdl2-dev \
libsdl2-2.0-0 \
xorg-dev \
x11-apps

## GNU scientific library, and other optional things
apt-get update && apt-get install -y \
gsl-bin \
libgsl-dev \
jq \
gnuplot \
libv4l-dev \
libv4l-0 
