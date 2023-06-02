#!/usr/bin/env bash

DOCKER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source $DOCKER_PATH/common.sh

SHELL=zsh

docker exec \
    -e COLORTERM=$COLORTERM \
    -e DISPLAY=${DISPLAY} \
    -u $USER \
    -it -w /offlinerl_root $DOCKER_NAME \
    env LANG=C.UTF-8 \
    /bin/$SHELL
