
# 3.8
FROM library/python@sha256:5b1dc84f5b565ef0a12c093734e76dc7fef2825d7713f90cc5634e1b32c21af1
WORKDIR /project

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils && apt-get install -y  \
    net-tools ffmpeg mencoder \
    && apt-get clean && \
    rm -r /var/lib/apt/lists/*
#    python3-opencv python3-numpy python3-scipy python3-plotly  python3-lxml \
#    python3-pillow python3-markdown python3-soupsieve python3-retrying python3-pydot \
#    python3-pipdeptree \

ARG VERSION="5.1.3"
ARG PIP_INDEX_URL="https://pypi.org/simple"
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

RUN python3 -m pip install -U pip
COPY requirements.* ./
RUN cat requirements.* > .requirements.txt
RUN python3 -m pip install -r .requirements.txt


RUN python3 -m pip freeze | tee /pip-freeze.txt
RUN python3 -m pip list | tee /pip-list.txt
RUN pipdeptree

ENV DISABLE_CONTRACTS 1
