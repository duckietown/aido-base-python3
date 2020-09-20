AIDO_REGISTRY ?= docker.io
PIP_INDEX_URL ?= https://pypi.org/simple

repo=aido-base-python3
branch=$(shell git rev-parse --abbrev-ref HEAD)
branch=daffy
tag=$(AIDO_REGISTRY)/duckietown/$(repo):$(branch)

all:



update-reqs:
	pur --index-url $(PIP_INDEX_URL) -r requirements1.txt -f -m '*' -o requirements1.resolved
	aido-update-reqs requirements1.resolved
	pur --index-url $(PIP_INDEX_URL) -r requirements2.txt -f -m '*' -o requirements2.resolved
	aido-update-reqs requirements2.resolved

bump:
	bumpversion minor

build: update-reqs

	docker build --pull -t $(tag) \
		--build-arg PIP_INDEX_URL=$(PIP_INDEX_URL)\
		--build-arg git_commit="$(shell git log -1 --format=%H)" \
		--build-arg git_branch="$(shell git rev-parse --abbrev-ref HEAD)" \
		--build-arg git_remote_url="$(shell git config --get remote.origin.url)" \
		--build-arg builder="$(shell whoami)" \
		.

push: build
	docker push $(tag)


	#		--build-arg PIP_INDEX_URL=$(PIP_INDEX_URL) \
	#		--build-arg PIP_TRUSTED_HOST=192.168.1.36 \
