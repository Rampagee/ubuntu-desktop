FROM ubuntu:18.04
MAINTAINER Nimbix/Xilinx

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20180124.1405}

ARG GIT_BRANCH
ENV GIT_BRANCH ${GIT_BRANCH:-master}

RUN apt-get -y update && \
    apt-get -y install curl && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/$GIT_BRANCH/install-nimbix.sh \
        | bash -s -- --setup-nimbix-desktop --image-common-branch $GIT_BRANCH

ADD help.html /etc/NAE/help.html
ADD AppDef.json /etc/NAE/AppDef.json

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443

# RUN apt-get install timezone
ENV TZ=America/Denver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
ENV TZ=America/Denver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV VAI_ROOT=/opt/vitis_ai
ENV VAI_HOME=/vitis_ai_home
ARG VERSION=1.3
ENV VERSION=$VERSION
ARG DATE=12/19/2020
ENV DATE=$DATE
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


RUN chmod 1777 /tmp \
    && mkdir /scratch \
    && chmod 1777 /scratch \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        bc \
        build-essential \
        bzip2 \
        ca-certificates \
        cmake \
        curl \
        g++ \
        git \
        locales \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libgtest-dev \
        libjson-c-dev \
        libssl-dev \
        libtool \
        libunwind-dev \
        make \
        openssh-client \
        openssl \
        python3 \
        python3-dev \
        python3-minimal \
        python3-numpy \
        python3-opencv \
        python3-pip \
        python3-setuptools \
        python3-venv \
        software-properties-common \
        sudo \
        tree \
        unzip \
        vim \
        wget \
        yasm \
        zstd \
        gtk2-engines-pixbuf \
        gedit

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8 \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && dpkg-reconfigure locales

# Tools for building vitis-ai-library in the docker container
RUN apt-get install -y \
        libavcodec-dev \
        libavformat-dev \
        libeigen3-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer1.0-dev \
        libgtest-dev \
        libgtk-3-dev \
        libgtk2.0-dev \
        libjpeg-dev \
        libopenexr-dev \
        libpng-dev \
        libswscale-dev \
        libtiff-dev \
        libwebp-dev \
        opencl-clhpp-headers \
        opencl-headers \
        pocl-opencl-icd \
        rpm \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get install -y \
        gcc-8 \
        g++-8 \
        gcc-9 \
        g++-9 \
    && cd /usr/src/gtest \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make \
    && make install

RUN pip3 install \
        Flask \
        setuptools \
        wheel

# Install XRT
RUN wget --progress=dot:mega -O xrt.deb https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.8.726_18.04-amd64-xrt.deb \
    && ls -lhd ./xrt.deb \
    && apt-get update -y \
    && apt-get install -y ./xrt.deb \
    && rm -fr /tmp/*

# cmake 3.16.1
RUN cd /tmp; wget --progress=dot:mega https://github.com/Kitware/CMake/releases/download/v3.16.1/cmake-3.16.1.tar.gz \
    && tar xvf cmake-3.16.1.tar.gz \
    && cd cmake-3.16.1 \
    && ./configure \
    && make -j \
    && make install \
    && rm -fr /tmp/* \
    && ldconfig

# glog 0.4.0
RUN cd /tmp \
    && wget --progress=dot:mega -O glog.0.4.0.tar.gz https://codeload.github.com/google/glog/tar.gz/v0.4.0 \
    && tar -xvf glog.0.4.0.tar.gz \
    && cd glog-0.4.0 \
    && ./autogen.sh \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=ON .. \
    && make -j \
    && make install \
    && rm -fr /tmp/*

# protobuf 3.4.0
RUN cd /tmp; wget --progress=dot:mega https://codeload.github.com/google/protobuf/zip/v3.4.0 \
    && unzip v3.4.0 \
    && cd protobuf-3.4.0 \
    && ./autogen.sh \
    && ./configure \
    && make -j \
    && make install \
    && ldconfig \
    && rm -fr /tmp/*

# opencv 3.4.3
RUN export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    && cd /tmp; wget --progress=dot:mega https://github.com/opencv/opencv/archive/3.4.3.tar.gz \
    && tar -xvf 3.4.3.tar.gz \
    && cd opencv-3.4.3 \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=ON .. \
    && make -j \
    && make install \
    && ldconfig \
    && export PATH="${VAI_ROOT}/conda/bin:${VAI_ROOT}/utility:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    && rm -fr /tmp/*

# gflags 2.2.2
RUN cd /tmp; wget --progress=dot:mega https://github.com/gflags/gflags/archive/v2.2.2.tar.gz \
    && tar xvf v2.2.2.tar.gz \
    && cd gflags-2.2.2 \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=ON .. \
    && make -j \
    && make install \
    && rm -fr /tmp/*

# ffmpeg 2.8.15
RUN cd /tmp; wget --progress=dot:mega https://github.com/FFmpeg/FFmpeg/archive/n2.8.15.tar.gz \
    && tar xvf n2.8.15.tar.gz \
    && cd FFmpeg-n2.8.15/ \
    && ./configure  --enable-pic --enable-shared \
    && make -j \
    && make install \
    && rm -fr /tmp/*

# pybind 2.5.0
RUN cd /tmp; git clone https://github.com/pybind/pybind11.git \
    && cd pybind11 \
    && git checkout v2.5.0 \
    && mkdir build \
    && cd build \
    && cmake -DPYBIND11_TEST=OFF .. \
    && make \
    && make install \
    && rm -fr /tmp/* \
    && chmod 777 /usr/lib/python3/dist-packages

RUN cd /tmp; wget --progress=dot:mega http://launchpadlibrarian.net/436533799/libjson-c4_0.13.1+dfsg-4_amd64.deb \
    && dpkg -i ./libjson-c4_0.13.1+dfsg-4_amd64.deb \
    && rm -fr /tmp/*

RUN cd /tmp \
    && wget --progress=dot:mega -O sdk.sh https://www.xilinx.com/bin/public/openDownload?filename=sdk-2020.2.0.0.sh  \
    && chmod a+x /tmp/sdk.sh \
    && /tmp/sdk.sh -y \
    && rm -fr /tmp/* \
    && chmod 777 /opt/petalinux/2020.2/sysroots/aarch64-xilinx-linux/

RUN echo $VERSION > /etc/VERSION.txt

ENV GOSU_VERSION 1.12

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc
RUN groupadd vitis-ai-group \
    && useradd --shell /bin/bash -c '' -m -g vitis-ai-group vitis-ai-user \
    && passwd -d vitis-ai-user \
    && usermod -aG sudo vitis-ai-user \
    && echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && curl -sSkLo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/local/bin/gosu \
    && echo ". $VAI_ROOT/conda/etc/profile.d/conda.sh" >> ~vitis-ai-user/.bashrc \
    && echo "conda activate base" >> ~vitis-ai-user/.bashrc \
    && echo "export VERSION=${VERSION}" >> ~vitis-ai-user/.bashrc \
    && echo "export BUILD_DATE=\"${DATE}\"" >> ~vitis-ai-user/.bashrc \
    && echo $VERSION > /etc/VERSION.txt \
    && echo $DATE > /etc/BUILD_DATE.txt \
    && echo 'export PS1="\[\e[91m\]Vitis-AI\[\e[m\] \w > "' >> ~vitis-ai-user/.bashrc \
    && mkdir -p ${VAI_ROOT} \
    && chown -R vitis-ai-user:vitis-ai-group ${VAI_ROOT}

# Set up Anaconda
USER vitis-ai-user
ENV MY_CONDA_CHANNEL="file:///scratch/conda-channel"

RUN cd /tmp \
    && wget --progress=dot:mega https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && /bin/bash ./miniconda.sh -b -p $VAI_ROOT/conda \
    && sudo ln -s $VAI_ROOT/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

ADD --chown=vitis-ai-user:vitis-ai-group cpu_conda/*.yml /scratch/
ADD --chown=vitis-ai-user:vitis-ai-group pip_requirements.txt /scratch/
ADD --chown=vitis-ai-user:vitis-ai-group pip_requirements_neptune.txt /scratch/

# Rebuild this layer every time
ARG CACHEBUST=1

# Create conda envs
RUN cd /scratch/ \
    && wget -O conda-channel.tar.gz --progress=dot:mega https://www.xilinx.com/bin/public/openDownload?filename=conda-channel_1.3.411-01.tar.gz \
    && tar -xzvf conda-channel.tar.gz \
    && . $VAI_ROOT/conda/etc/profile.d/conda.sh \
    && conda env create -f /scratch/vitis-ai-pytorch.yml \
        && conda activate vitis-ai-pytorch \
        && pip install -r /scratch/pip_requirements.txt \
    && conda env create -f /scratch/vitis-ai-caffe.yml \
        && conda activate vitis-ai-caffe \
        && pip install -r /scratch/pip_requirements.txt \
    && conda env create -f /scratch/vitis-ai-tensorflow.yml \
        && conda activate vitis-ai-tensorflow \
        && pip install -r /scratch/pip_requirements.txt \
    && conda env create -f /scratch/vitis-ai-tensorflow2.yml \
        && conda activate vitis-ai-tensorflow2 \
        && pip install -r /scratch/pip_requirements.txt \
        && pip install --ignore-installed tensorflow==2.3.0 \
    && conda env create -f /scratch/vitis-ai-neptune.yml \
        && conda activate vitis-ai-neptune \
        && pip install -r /scratch/pip_requirements_neptune.txt \
    && mkdir -p $VAI_ROOT/compiler \
        && conda activate vitis-ai-caffe \
        && sudo cp -r $CONDA_PREFIX/lib/python3.6/site-packages/vaic/arch $VAI_ROOT/compiler/arch \
    && rm -fr /scratch/*

# Rebuild this layer every time
USER root
ARG CACHEBUST=1
RUN cd /tmp/ \
    && wget -O libunilog.deb https://www.xilinx.com/bin/public/openDownload?filename=libunilog_1.3.0-r20_amd64.deb \
    && wget -O libtarget-factory.deb https://www.xilinx.com/bin/public/openDownload?filename=libtarget-factory_1.3.0-r22_amd64.deb \
    && wget -O libxir.deb https://www.xilinx.com/bin/public/openDownload?filename=libxir_1.3.0-r29_amd64.deb \
    && wget -O libvart.deb https://www.xilinx.com/bin/public/openDownload?filename=libvart_1.3.0-r53_amd64.deb \
    && wget -O libvitis_ai_library.deb https://www.xilinx.com/bin/public/openDownload?filename=libvitis%5fai%5flibrary_1.3.0-r45_amd64.deb \
    && wget -O libbutler-base.deb https://www.xilinx.com/bin/public/openDownload?filename=libbutler-base_1.3.0_amd64.deb \
    && wget -O librt-engine.deb https://www.xilinx.com/bin/public/openDownload?filename=librt-engine_1.3.0-r106_amd64.deb \
    && wget -O aks.deb https://www.xilinx.com/bin/public/openDownload?filename=aks_1.3.0-r3020_amd64.deb \
    && apt-get install -y --no-install-recommends /tmp/*.deb \
    && rm -rf /tmp/* \
    && ldconfig

RUN apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /scratch/*

RUN cd /scratch \
    && wget https://www.xilinx.com/bin/public/openDownload?filename=alveo_xclbin-1.3.0.tar.gz -O alveo_xclbin-1.3.0.tar.gz \
    && tar xfz alveo_xclbin-1.3.0.tar.gz \
    && rm alveo_xclbin-1.3.0.tar.gz 

ADD ./login.sh /etc/
ENTRYPOINT ["/etc/login.sh"]

ADD ./banner.sh /etc/

ADD ./README.txt /etc/

ADD ./overlay_settle.sh /etc/
