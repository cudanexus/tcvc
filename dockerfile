ARG CUDA_VERSION=10.0
ARG OS_VERSION=18.04

FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel-ubuntu${OS_VERSION}
LABEL maintainer="NVIDIA CORPORATION"

ENV TRT_VERSION 7.2.3.4
ENV AWS_ACCESS_KEY_ID="Add aws"
ENV AWS_SECRET_ACCESS_KEY="Add aws"



SHELL ["/bin/bash", "-c"]

# Setup user account
ARG uid=1000
ARG gid=1000
RUN groupadd -r -f -g ${gid} trtuser && useradd -o -r -u ${uid} -g ${gid} -ms /bin/bash trtuser
RUN usermod -aG sudo trtuser
RUN echo 'trtuser:nvidia' | chpasswd
RUN mkdir -p /workspace && chown trtuser /workspace
# RUN apt-key del 7fa2af80
# RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub
# RUN rm /etc/apt/sources.list.d/nvidia-ml.list && apt-get clean


# Install requried libraries
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    wget \
    zlib1g-dev \
    git \
    pkg-config \
    sudo \
    ssh \
    libssl-dev \
    pbzip2 \
    pv \
    bzip2 \
    unzip \
    devscripts \
    lintian \
    fakeroot \
    dh-make \
    nano \
    build-essential

# Install python3
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.8 \
        python3.8-dev \
        wget\
        curl\
        python3.8-distutils && \
    ln -s /usr/bin/python3.8 /usr/local/bin/python && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.8 get-pip.py
# WORKDIR /

COPY ./requirements.txt /home/src/requirements.txt
COPY ./models /home/src/codes/models
WORKDIR /home/src/codes/

RUN pip install -r ../requirements.txt
RUN echo "trtuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" >> ~/.bashrc &&\
    echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc &&\
    source ~/.bashrc
USER trtuser
RUN cd ./models/archs/networks/channelnorm_package && \
    sudo python setup.py develop
RUN cd ./models/archs/networks/correlation_package && \
    sudo python setup.py develop
RUN cd ./models/archs/networks/resample2d_package && \
    sudo python setup.py develop



RUN ["/bin/bash"]
