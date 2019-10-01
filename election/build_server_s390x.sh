#!/bin/bash

DOCKER_IMG="server"

docker image inspect "${DOCKER_IMG}:latest" &> /dev/null || {
  docker build ./ -f Dockerfile.s390x_server -t "${DOCKER_IMG}":latest --no-cache
}

docker run --name ${DOCKER_IMG} -v "${PWD}":/root/go/src/k8s.io/contrib/election \
  -it ${DOCKER_IMG}:latest -c \
  "cd /root/go/src/k8s.io/contrib/election && make server"
docker stop ${DOCKER_IMG}
docker rm ${DOCKER_IMG}

if [ "$1" == "--cleanup" ]; then
  docker image rm ${DOCKER_IMG}:latest
fi
