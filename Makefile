BIN=cardigann
PREFIX=github.com/cardigann/cardigann
GOVERSION=$(shell go version)
GOBIN=$(shell go env GOBIN)
VERSION=$(shell git describe --tags --candidates=1 --dirty)
FLAGS=-X main.Version=$(VERSION) -s -w
SRC=$(shell find ./indexer ./server ./config ./torznab)

test:
	go test -v ./indexer ./server ./config ./torznab

build: server/static.go indexer/definitions.go
	go build -o $(BIN) -ldflags="$(FLAGS)" *.go

test-defs:
	find definitions -name '*.yml' -print -exec go run *.go test {} \;

indexer/definitions.go: $(shell find definitions)
	esc -o indexer/definitions.go -prefix templates -pkg indexer definitions/

server/static.go: $(shell find web/src)
	cd web; npm run build
	go generate -v ./server

install:
	go install -ldflags="$(FLAGS)" $(PREFIX)

clean-statics:
	-rm server/static.go indexer/definitions.go

clean:
	-rm -rf web/build
	-rm -rf $(BIN)*

run-dev:
	cd web/; npm start &
	rerun $(PREFIX) server --debug --passphrase "llamasrock"

EQUINOX_CHANNEL ?= edge
release: server/static.go indexer/definitions.go
	equinox release \
	--version="$(VERSION)" \
	--config ./equinox.yml \
	--channel $(EQUINOX_CHANNEL) \
	-- -ldflags="$(FLAGS)" $(PREFIX)

cacert.pem:
	wget -N https://curl.haxx.se/ca/cacert.pem

$(BIN)-linux-amd64: $(SRC)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $@ -ldflags="$(FLAGS)" *.go

DOCKER_TAG ?= cardigann:$(VERSION)

docker: $(BIN)-linux-amd64 cacert.pem
	docker build -t $(DOCKER_TAG) .
	docker run --rm -it $(DOCKER_TAG) version
