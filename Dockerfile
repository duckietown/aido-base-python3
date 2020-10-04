ARG AIDO_REGISTRY

FROM ${AIDO_REGISTRY}/python:3.8
WORKDIR /project

RUN apt-get update && apt-get install -y  net-tools ffmpeg mencoder && apt-get clean && \
    rm -r /var/lib/apt/lists/*

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

RUN pip install -U pip>=20.2 && rm -rf /root/.cache


COPY requirements1.*  ./
RUN pip install --use-feature=2020-resolver  -r requirements1.resolved && rm -rf /root/.cache

COPY requirements2.* ./
RUN pip install --use-feature=2020-resolver   -r requirements2.resolved && rm -rf /root/.cache

RUN pip freeze | tee /pip-freeze.txt
RUN pip list | tee /pip-list.txt
RUN pipdeptree

ENV DISABLE_CONTRACTS 1
