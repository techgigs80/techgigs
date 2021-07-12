# Copyright (c) lucas.ku(ruria80@gmail.com)
# Distributed under the terms of the Modified BSD License.

# nvidia/cuda tag from https://hub.docker.com/r/nvidia/cuda/tags
# e.g. nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# FROM nvidia/cudagl:10.0-devel-ubuntu18.04 as base1
# FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04 as base

ARG BASE_TAG=10.1-cudnn7-devel-ubuntu18.04
FROM nvidia/cuda:${BASE_TAG} as base

LABEL maintainer="lucas.ku <ruria80@gmail.com>"

# Versions
ARG XRDP_VER="0.9.10"
ENV XRDP_VER=${XRDP_VER}
ARG XORGXRDP_VER="0.2.10"
ENV XORGXRDP_VER=${XORGXRDP_VER}
ARG XRDPPULSE_VER="0.3"
ENV XRDPPULSE_VER=${XRDPPULSE_VER}

USER root

# Install the necessary os packages
ENV DEBIAN_FRONTEND noninteractive

COPY posco_ict_sha_256_encryted.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list
ENV BUILD_DEPS="apt-utils software-properties-common \
                git autoconf pkg-config libssl-dev libpam0g-dev \
                libx11-dev libxfixes-dev libxrandr-dev nasm xsltproc flex \
                bison libxml2-dev dpkg-dev libcap-dev libfuse-dev libpulse-dev libtool \
                xserver-xorg-dev wget ssl-cert"


RUN apt-get update --fix-missing \
    && apt-get -yq full-upgrade \
    && apt-get install -yq sudo apt-utils software-properties-common $BUILD_DEPS
RUN apt-get install -yq build-essential autoconf automake \
                       autotools-dev dh-make debhelper devscripts fakeroot \
                       xutils lintian pbuilder 

# Build xrdp
WORKDIR /tmp
RUN apt-get build-dep -y xrdp
RUN wget --no-check-certificate https://github.com/neutrinolabs/xrdp/releases/download/v"${XRDP_VER}"/xrdp-"${XRDP_VER}".tar.gz
RUN tar -zxf xrdp-"${XRDP_VER}".tar.gz
COPY xrdp /tmp/xrdp-"${XRDP_VER}"/
WORKDIR /tmp/xrdp-"${XRDP_VER}"
RUN dpkg-buildpackage -rfakeroot -uc -b
RUN ls /tmp
RUN dpkg -i /tmp/xrdp_"${XRDP_VER}"-1_amd64.deb

WORKDIR /tmp
RUN apt-get build-dep -y xorgxrdp
RUN wget --no-check-certificate https://github.com/neutrinolabs/xorgxrdp/releases/download/v"${XORGXRDP_VER}"/xorgxrdp-"${XORGXRDP_VER}".tar.gz
RUN tar -zxf xorgxrdp-"$XORGXRDP_VER".tar.gz
COPY xorgxrdp /tmp/xorgxrdp-"${XORGXRDP_VER}"/
WORKDIR /tmp/xorgxrdp-"${XORGXRDP_VER}"
RUN dpkg-buildpackage -rfakeroot -uc -b
RUN dpkg -i /tmp/xorgxrdp_"${XORGXRDP_VER}"-1_amd64.deb

# Prepare Pulse Audio
WORKDIR /tmp
RUN apt-get source pulseaudio
RUN apt-get build-dep -yy pulseaudio
WORKDIR /tmp/pulseaudio-11.1
RUN dpkg-buildpackage -rfakeroot -uc -b

# Build Pulse Audio module
WORKDIR /tmp
RUN wget --no-check-certificate https://github.com/neutrinolabs/pulseaudio-module-xrdp/archive/v"${XRDPPULSE_VER}".tar.gz -O pulseaudio-module-xrdp-"${XRDPPULSE_VER}".tar.gz
RUN tar -zxf pulseaudio-module-xrdp-"${XRDPPULSE_VER}".tar.gz
WORKDIR /tmp/pulseaudio-module-xrdp-"${XRDPPULSE_VER}"
RUN ./bootstrap
RUN ./configure PULSE_DIR=/tmp/pulseaudio-11.1
RUN export NUMPROC=$(nproc --all) \
    && make -j$NUMPROC \
    && make install

FROM base
ARG ADDITIONAL_PACKAGES=""
ENV ADDITIONAL_PACKAGES=${ADDITIONAL_PACKAGES}

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing && apt-get -yq full-upgrade \
    && apt-get install -yq ca-certificates crudini \
                          firefox less locales openssh-server pepperflashplugin-nonfree \
                          pulseaudio ssl-cert sudo supervisor uuid-runtime vim wget xauth \
                          xautolock xfce4 xfce4-clipman-plugin xfce4-cpugraph-plugin \
                          xfce4-netload-plugin xfce4-screenshooter xfce4-taskmanager \
                          xfce4-terminal xfce4-xkb-plugin xprintidle $ADDITIONAL_PACKAGES \
    && rm -rf /var/cache/apt-get /var/lib/apt/lists \
    && mkdir -p /var/lib/xrdp-pulseaudio-installer
COPY --from=base /usr/lib/pulse-11.1/modules/module-xrdp-sink.so \
                    /usr/lib/pulse-11.1/modules/module-xrdp-source.so \
                    /var/lib/xrdp-pulseaudio-installer/
COPY --from=base /tmp/xrdp_${XRDP_VER}-1_amd64.deb /tmp/xorgxrdp_${XORGXRDP_VER}-1_amd64.deb /tmp/
RUN dpkg -i /tmp/xrdp_"${XRDP_VER}"-1_amd64.deb /tmp/xorgxrdp_"${XORGXRDP_VER}"-1_amd64.deb && \
    rm -rf /tmp/xrdp_"${XRDP_VER}"-1_amd64.deb /tmp/xorgxrdp_"${XORGXRDP_VER}"-1_amd64.deb

COPY bin /usr/bin
COPY etc /etc
COPY autostart /etc/xdg/autostart

# Configure
RUN mkdir /var/run/dbus \
    && cp /etc/X11/xrdp/xorg.conf /etc/X11 \
    && sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config \
    && sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini \
    && locale-gen en_US.UTF-8 \
    && echo "xfce4-session" > /etc/skel/.Xclients \
    && cp -r /etc/ssh /ssh_orig \
    && rm -rf /etc/ssh/* \
    && rm -rf /etc/xrdp/rsakeys.ini /etc/xrdp/*.pem

# Install korean and build-essential
RUN apt-get update --fix-missing && apt-get install -yq --no-install-recommends software-properties-common build-essential linux-generic

RUN apt-get install -yq build-essential autoconf automake autotools-dev dh-make \
                       debhelper devscripts fakeroot xutils lintian pbuilder \
                       language-selector-gnome fonts-nanum fcitx fcitx-hangul

RUN apt-get install -yq language-pack-ko language-pack-gnome-ko language-pack-ko-base language-pack-gnome-ko-base
RUN apt-get install -yq bzip2 ca-certificates libmysqlclient-dev wget

RUN apt-get install -yq vim curl nginx supervisor virtualenv virtualenvwrapper sudo nano 
#libcudnn7=7.4.1.5-1+cuda10.0 libcudnn7-dev=7.4.1.5-1+cuda10.0

RUN apt-get update --fix-missing && apt-get install -yq --no-install-recommends \
        pkg-config \
       # libglvnd-dev libglvnd-dev:i386 \
       # libgl1-mesa-dev libgl1-mesa-dev:i386 \
       # libegl1-mesa-dev libegl1-mesa-dev:i386 \
       # libgles2-mesa-dev libgles2-mesa-dev:i386 \
        python3-dev zlib1g-dev libjpeg-dev cmake swig \
        python-pyglet python3-opengl libboost-all-dev libsdl2-dev \
        libosmesa6-dev patchelf ffmpeg xvfb

RUN wget --no-check-certificate -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && \
    echo "deb http://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list && \
    apt-get update --fix-missing && \
    apt-get install -yq sublime-text checkinstall libreadline-gplv2-dev libncursesw5-dev \
    libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

ENV VIRTUAL_ENV=/opt/tf1.3
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"


#################
###  pycharm  ###
#################
RUN mkdir /home/dev
RUN cd /home/dev
WORKDIR /home/dev
RUN wget --no-check-certificate https://download.jetbrains.com/python/pycharm-community-2018.1.2.tar.gz
RUN tar -xvf pycharm-community-2018.1.2.tar.gz
RUN mv pycharm-community-2018.1.2 pyc
RUN ln -s /home/dev/pyc/bin/pycharm.sh /usr/bin/pycharm
RUN rm -f pycharm-community-2018.1.2.tar.gz
# Install dependencies:
COPY requirements.txt .
RUN pip install -r requirements.txt

RUN apt-get clean && apt-get update --fix-missing && apt-get install -yq locales
RUN locale-gen ko_KR.UTF-8
RUN locale-gen en_US.UTF-8

RUN apt-get update --fix-missing && sudo apt-get install -yq cmake libopenmpi-dev python3-dev zlib1g-dev
RUN mkdir -p /home/data
RUN /etc/init.d/dbus start
RUN echo "LANG=ko_KR.UTF-8" >> /etc/default/locale
RUN echo "LC_MESSAGES=POSIX" >> /etc/default/locale
RUN echo "export PATH=$PATH:/usr/sbin/" >> /etc/profile
RUN echo "source /opt/tf1.3/bin/activate" >> ~/.bashrc

#RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
#RUN tar -zxvf ta-lib-0.4.0-src.tar.gz && cd /home/dev/ta-lib/ && ./configure --prefix=/usr && make && make install


########################
###  OPENCV INSTALL  ###
########################
ARG OPENCV_VERSION=3.4.4
ARG OPENCV_INSTALL_PATH=/opencv/usr

RUN echo "deb http://mirrors.kernel.org/ubuntu/ xenial main" >> /etc/apt/sources.list
RUN apt-get update --fix-missing \
    && apt-get install -yq build-essential cmake git wget unzip \
        yasm pkg-config \
        libswscale-dev libtbb2 libtbb-dev libtiff-dev libjasper-dev \
        libavformat-dev libpq-dev libglew-dev libtiff5-dev zlib1g-dev \
        libjasper-dev libavcodec-dev libavformat-dev libavutil-dev \
        libpostproc-dev libswscale-dev libeigen3-dev libtbb-dev libgtk2.0-dev \
        python-dev python-numpy python3-dev python3-numpy \
## VTK
#libvtk6-dev \
    ## Cleanup
    && rm -rf /var/lib/apt/lists/*

#RUN pip install numpy

## Create install directory
## Force success as the only reason for a fail is if it exist
RUN mkdir -p $OPENCV_INSTALL_PATH; exit 0

WORKDIR /opencv

## Single command to reduce image size
## Build opencv
RUN wget --no-check-certificate -O opencv_$OPENCV_VERSION.zip https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
RUN wget --no-check-certificate -O opencv_contrib_$OPENCV_VERSION.zip https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip
RUN apt-get update --fix-missing \
    && apt-get install -yq libavcodec-dev libavformat-dev libswscale-dev \
                          libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
                          libgtk-3-dev libpng-dev libjpeg-dev libopenexr-dev \
                          libtiff-dev libwebp-dev

#RUN apt-get install autoconf automake libtool curl make g++ unzip -y
#RUN git clone https://github.com/google/protobuf.git
#RUN cd protobuf && \
#    git submodule update --init --recursive && \
#    ./autogen.sh && \
#    ./configure
 
#RUN cd protobuf && \
#    make && \
#    make check
# RUN cd protobuf &&  \
#    make install && \
#    ldconfig
RUN apt-get install -yq libavresample-dev libxvidcore-dev x264 libx264-dev libfaac-dev \
                       libfaac-dev libmp3lame-dev libvorbis-dev libdc1394-22 libdc1394-22-dev \
                       libv4l-dev v4l-utils libatlas-base-dev gfortran protobuf-compiler \
                       libprotobuf-dev libprotobuf-c-dev libprotobuf-c1
                      #  libprotobuf-dev protobuf-compiler

# COPY ./build/$OPENCV_VERSION.zip .
# COPY ./build/opencv_contrib$OPENCV_VERSION.zip .
RUN unzip opencv_contrib_$OPENCV_VERSION.zip
RUN unzip opencv_$OPENCV_VERSION.zip \
    && mkdir ./opencv-$OPENCV_VERSION/cmake_binary \
    && cd ./opencv-$OPENCV_VERSION/cmake_binary \
    && cmake -DBUILD_TIFF=ON \
             -DBUILD_opencv_java=OFF \
             -DBUILD_SHARED_LIBS=OFF \
             -DWITH_CUDA=ON \
            #  -DENABLE_FAST_MATH=1 \
            #  -DCUDA_FAST_MATH=1 \
            #  -DWITH_CUBLAS=1 \
             -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.0 \
            ##
            ## Should compile for most card
            ## 3.5 binary code for devices with compute capability 3.5 and 3.7,
            ## 5.0 binary code for devices with compute capability 5.0 and 5.2,
            ## 6.0 binary code for devices with compute capability 6.0 and 6.1,
             -DCUDA_ARCH_BIN="5.3,6.0,6.1,7.0,7.5" \
             -DCUDA_ARCH_PTX="6.0" \
             -D OPENCV_DNN_CUDA=OFF \
             -DBUILD_PROTOBUF=ON \
             -DPROTOBUF_UPDATE_FILES=OFF \
            #  -DCUDA_ARCH_BIN='5.0' \
            #  -DCUDA_ARCH_PTX="" \
            ##
            ## AVX in dispatch because not all machines have it
            -DCPU_DISPATCH=AVX,AVX2 \
            -DENABLE_PRECOMPILED_HEADERS=OFF \
            -DWITH_OPENGL=OFF \
            -DWITH_OPENCL=OFF \
            -DWITH_QT=OFF \
            -DWITH_IPP=ON \
            -DWITH_TBB=ON \
            -DFORCE_VTK=ON \
            -DWITH_EIGEN=ON \
            -DWITH_V4L=ON \
            -DWITH_XINE=ON \
            -DWITH_GDAL=ON \
            -DWITH_1394=OFF \
            -DWITH_FFMPEG=ON \
            -DBUILD_TESTS=OFF \
            -DBUILD_PERF_TESTS=OFF \
            -DCMAKE_BUILD_TYPE=RELEASE \
            -DCMAKE_INSTALL_PREFIX=$OPENCV_INSTALL_PATH \
            -DOPENCV_EXTRA_MODULES_PATH=/opencv/opencv_contrib-$OPENCV_VERSION/modules \
            .. 
    ##
    ## Add variable to enable make to use all cores

RUN cd ./opencv-$OPENCV_VERSION/cmake_binary \
    && export NUMPROC=$(nproc --all) \
    && make -j$NUMPROC install
    ## Remove following lines if you need to move openCv
    #&& rm /$OPENCV_VERSION.zip \
    #&& rm -r /opencv-$OPENCV_VERSION

## Compress the openCV files so you can extract them from the docker easily 
# RUN tar cvzf opencv-$OPENCV_VERSION.tar.gz --directory=$OPENCV_INSTALL_PATH .

RUN python /opencv/usr/python/setup.py install
#RUN cp -r $OPENCV_INSTALL_PATH /
#RUN cp -r $OPENCV_INSTALL_PATH/lib/python3.6/* /usr/lib/python3.7
# END OPENCV


RUN chmod 777 -R /opt/tf1.3
# Docker config
EXPOSE 3389 22 9001
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["supervisord"]

# libprotobuf-dev protobuf-compiler
# libegl1-mesa-dev libegl1-mesa-dev:i386
# libgl1-mesa-dev libgl1-mesa-dev:i386
# libgles2-mesa-dev libgles2-mesa-dev:i386
# libglvnd-dev libglvnd-dev:i386