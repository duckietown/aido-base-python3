ARG AIDO_REGISTRY

# 3.8
FROM library/python@sha256:5b1dc84f5b565ef0a12c093734e76dc7fef2825d7713f90cc5634e1b32c21af1
WORKDIR /project

RUN apt-get update && apt-get install -y apt-utils && apt-get install -y  \
    net-tools ffmpeg mencoder \
    python3-opencv python3-numpy python3-scipy python3-plotly  python3-lxml \
    python3-pillow python3-markdown python3-soupsieve python3-retrying python3-pydot \
    python3-pipdeptree \
    && apt-get clean && \
    rm -r /var/lib/apt/lists/*

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

RUN pip3 install -U pip>=20.2
COPY requirements.* ./
RUN cat requirements.* > .requirements.txt
RUN pip3 install --use-feature=2020-resolver -r .requirements.txt


RUN pip freeze | tee /pip-freeze.txt
RUN pip list | tee /pip-list.txt
RUN pipdeptree

ENV DISABLE_CONTRACTS 1
