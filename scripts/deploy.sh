#!/bin/bash
set -eu -o pipefail

# DOCKER_TAG ?= cardigann:$(VERSION)

# docker: $(BIN)-linux-amd64 cacert.pem
# 	docker build -t $(DOCKER_TAG) .
# 	docker run --rm -it $(DOCKER_TAG) version

# wget -N https://curl.haxx.se/ca/cacert.pem

docker_build() {
  touch server/static.go
  make cardigann-linux-amd64
  file cardigann-linux-amd64
  make docker DOCKER_TAG=${IMAGE}:${COMMIT}
  docker tag ${IMAGE}:${COMMIT} ${IMAGE}:latest
}

docker_login() {
  docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
}

echo "Building docker image for ${IMAGE}:${COMMIT}"
docker_build

# Build the docker image


# Download and unpack the most recent Equinox release tool
# wget https://bin.equinox.io/c/mBWdkfai63v/release-tool-stable-linux-amd64.tgz
# tar -vxf release-tool-stable-linux-amd64.tgz

# # TODO: Replace app_xxx with correct application ID
# ./equinox release \
# 	--version="$(VERSION)" \
# 	--config ./equinox.yml \
# 	--channel $(EQUINOX_CHANNEL) \
# 	-- -ldflags="$(FLAGS)" $(PREFIX)


# docker push ${IMAGE}
