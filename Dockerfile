FROM python:3.8
WORKDIR /project

RUN apt-get update && apt-get install -y  net-tools ffmpeg mencoder && apt-get clean && \
    rm -r /var/lib/apt/lists/*


RUN pip install -U pip && rm -rf /root/.cache


ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}

#ENV PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST}

#
#
#RUN env
#RUN ifconfig
#RUN env
#RUN curl http://192.168.1.36:3141

COPY requirements1.*  ./
RUN pip install   -r requirements1.resolved && rm -rf /root/.cache

COPY requirements2.* ./
RUN pip install    -r requirements2.resolved && rm -rf /root/.cache

RUN pip freeze | tee /pip-freeze.txt
RUN pip list | tee /pip-list.txt
RUN pipdeptree

ENV DISABLE_CONTRACTS 1
 

ARG git_repo
ARG git_commit
ARG git_branch
ARG git_remote_url
ARG builder

LABEL L.${git_repo}.AIDO_REGISTRY="${AIDO_REGISTRY}"
LABEL L.${git_repo}.PIP_INDEX_URL="${PIP_INDEX_URL}"
LABEL L.${git_repo}.git_repo=${git_repo}
LABEL L.${git_repo}.git_commit=${git_commit}
LABEL L.${git_repo}.git_branch=${git_branch}
LABEL L.${git_repo}.git_remote_url=${git_remote_url}
LABEL L.${git_repo}.builder=${builder}
