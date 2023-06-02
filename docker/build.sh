#!/bin/bash
DOCKER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_DIR="$(cd "(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

docker build -t corl/corl_dev --build-arg -f "${DOCKER_PATH}/dev"