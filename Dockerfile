
# 3.8
FROM library/python@sha256:0e699388e0d1e2fbeabf6ce25aae3f0014d5647a10c7d23053be9a7da3c9132a
WORKDIR /project

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils && apt-get install -y  \
    net-tools ffmpeg mencoder \
    && apt-get clean && \
    rm -r /var/lib/apt/lists/*
#    python3-opencv python3-numpy python3-scipy python3-plotly  python3-lxml \
#    python3-pillow python3-markdown python3-soupsieve python3-retrying python3-pydot \
#    python3-pipdeptree \


ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

RUN pip3 install -U "pip>=20.2"
COPY requirements.* ./
RUN cat requirements.* > .requirements.txt
RUN pip3 install --use-feature=2020-resolver -r .requirements.txt


RUN pip freeze | tee /pip-freeze.txt
RUN pip list | tee /pip-list.txt
RUN pipdeptree

ENV DISABLE_CONTRACTS 1
