AIDO_REGISTRY ?= docker.io
PIP_INDEX_URL ?= https://pypi.org/simple

repo0=$(shell basename -s .git `git config --get remote.origin.url`)
repo=$(shell echo $(repo0) | tr A-Z a-z)
branch=$(shell git rev-parse --abbrev-ref HEAD)
branch=daffy
tag=$(AIDO_REGISTRY)/duckietown/$(repo):$(branch)

all:



update-reqs:
	pur --index-url $(PIP_INDEX_URL) -r requirements.txt -f -m '*' -o requirements.resolved
	aido-update-reqs requirements.resolved

bump: # v2
	bumpversion patch
	git push --tags
	git push

build_options=\
		--build-arg PIP_INDEX_URL=$(PIP_INDEX_URL)\
		--build-arg AIDO_REGISTRY=$(AIDO_REGISTRY)\
		$(shell aido-labels)

build: update-reqs
	docker build --pull -t $(tag) $(build_options) .

push: build
	docker push $(tag)


	#		--build-arg PIP_INDEX_URL=$(PIP_INDEX_URL) \
	#		--build-arg PIP_TRUSTED_HOST=192.168.1.36 \

