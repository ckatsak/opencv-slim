# syntax=docker/dockerfile:1

FROM python:3.11.0-slim-bullseye
LABEL maintainer="ckatsak@gmail.com"

ENV OPENCV_VERSION="4.6.0"

ENV LIBS="libswscale-dev \
          libtbb-dev \
          libjpeg-dev \
          libpng-dev \
          libtiff-dev \
          libavformat-dev \
          libavcodec-dev \
          libpq-dev"
ENV PKGS="cmake make g++ wget unzip yasm pkg-config"

RUN apt-get -y update \
    && apt-get install --no-install-recommends -y $LIBS $PKGS \
    && pip install numpy \
    && cd / \
    && wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
    && unzip opencv.zip \
    && mkdir _build \
    && cd _build \
    && cmake \
        -DWITH_CUDA=OFF \
        -DWITH_OPENCL=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DCMAKE_BUILD_TYPE=RELEASE \
        ../opencv-${OPENCV_VERSION} \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd / \
    && rm -rf /opencv.zip /opencv-${OPENCV_VERSION} /_build \
    && apt-get remove --purge --auto-remove -y $PKGS \
    && apt-get clean && apt-get autoclean && apt-get autoremove \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /root/.[acpw]* \
    && rm -f /var/cache/apt/archives/*.deb \
        /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin
