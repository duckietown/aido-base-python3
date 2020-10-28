ARG AIDO_REGISTRY

FROM ${AIDO_REGISTRY}/python:3.8
WORKDIR /project

RUN apt-get update && apt-get install -y  net-tools ffmpeg mencoder && apt-get clean && \
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
