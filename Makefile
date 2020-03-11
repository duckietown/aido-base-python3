repo=aido-base-python3
branch=$(shell git rev-parse --abbrev-ref HEAD)
tag=duckietown/$(repo):$(branch)

bump:
	bumpversion minor

build:
	pur -r requirements1.txt -f -m '*' -o requirements1.resolved
	pur -r requirements2.txt -f -m '*' -o requirements2.resolved
	docker build --pull -t $(tag) \
		--build-arg git-commit="$(shell git log -1 --format=%H)" \
		--build-arg git-branch="$(shell git rev-parse --abbrev-ref HEAD)" \
		--build-arg git-remote-url="$(shell git config --get remote.origin.url)" \
		--build-arg builder="$(shell whoami)" \
		.

push: build
	docker push $(tag)

