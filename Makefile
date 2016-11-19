NAME=nsrl
VERSION=$(shell cat VERSION)
DEV_RUN_OPTS ?= 60B7C0FEAD45F2066E5B805A91F4F0FC

dev:
	docker build -f Dockerfile -t $(NAME):dev .
	docker run --rm $(NAME):dev $(DEV_RUN_OPTS)

build:
	docker build -t malice/$(NAME):$(VERSION) .

size:	
	sed -i.bu 's/docker image-.*-blue/docker image-$(shell docker images --format "{{.Size}}" malice/$(NAME):$(VERSION))-blue/g' README.md

release:
	rm -rf release && mkdir release
	go get github.com/progrium/gh-release/...
	cp build/* release
	gh-release create maliceio/malice-$(NAME) $(VERSION) \
		$(shell git rev-parse --abbrev-ref HEAD) $(VERSION)
	# glu hubtag maliceio/malice-$(NAME) $(VERSION)

circleci:
	rm -f ~/.gitconfig
	go get -u github.com/gliderlabs/glu
	glu circleci

.PHONY: build release
