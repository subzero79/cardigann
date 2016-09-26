#!/bin/bash
set -eu -o pipefail

# Build the docker image
touch server/static.go
make cardigann-linux-amd64
file cardigann-linux-amd64
make docker DOCKER_TAG=${IMAGE}:${COMMIT}
docker tag ${IMAGE}:${COMMIT} ${IMAGE}:latest
docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"

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
