FROM python:3.7
WORKDIR /project

RUN apt-get update && apt-get install -y ffmpeg mencoder && apt-get clean && \
    rm -r /var/lib/apt/lists/*


RUN pip install -U pip && rm -rf /root/.cache

COPY requirements1.txt requirements1.resolved ./
RUN pip install -r requirements1.txt && rm -rf /root/.cache

COPY requirements2.txt requirements2.resolved ./
RUN pip install -r requirements2.txt && rm -rf /root/.cache

RUN pip freeze | tee /pip-freeze.txt
RUN pip list | tee /pip-list.txt
RUN pipdeptree

ENV DISABLE_CONTRACTS 1

LABEL version="5.1.0"
ARG git-commit
ARG git-branch
ARG git-remote-url
ARG builder

LABEL git-commit=${git-commit}
LABEL git-branch=${git-branch}
LABEL git-remote-url=${git-remote-url}
LABEL builder=${builder}

