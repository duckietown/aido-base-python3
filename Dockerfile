ARG ARCH=amd64
ARG DISTRO=daffy
ARG BASE_TAG=${DISTRO}-${ARCH}

ARG BASE_IMAGE=dt-base-environment
ARG DOCKER_REGISTRY=docker.io

# define base image
FROM ${DOCKER_REGISTRY}/duckietown/${BASE_IMAGE}:${BASE_TAG}

WORKDIR /project

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils && apt-get install -y  \
    net-tools ffmpeg mencoder python3 python3-dev \
    && apt-get clean && \
    rm -r /var/lib/apt/lists/*
#    python3-opencv python3-numpy python3-scipy python3-plotly  python3-lxml \
#    python3-pillow python3-markdown python3-soupsieve python3-retrying python3-pydot \
#    python3-pipdeptree \

ARG VERSION="5.1.4"
ARG PIP_INDEX_URL="https://pypi.org/simple/"
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

RUN python3 -m pip install -U pip
COPY requirements.* ./
RUN cat requirements.* > .requirements.txt

RUN echo PLATFORM="${TARGETPLATFORM}" ARCH="${ARCH}" \
    && case ${TARGETPLATFORM} in \
         "linux/arm/v7") apt-get update && apt-get install -y python3-opencv  && apt-get clean && rm -r /var/lib/apt/lists/*;; \
         "linux/arm64") python3 -m pip install opencv-python==4.4.0.44   ;; \
         "linux/amd64")   python3 -m pip install opencv-python==4.4.0.44  ;; \
    esac;

RUN python3 -m pip install -r .requirements.txt

RUN python3 -m pip freeze | tee /pip-freeze.txt
RUN python3 -m pip list | tee /pip-list.txt
RUN pipdeptree

ENV DISABLE_CONTRACTS 1
