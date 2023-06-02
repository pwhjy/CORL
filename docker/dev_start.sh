#!/bin/bash
DOCKER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"


source $DOCKER_PATH/common.sh

# docker pull $IMG

function local_volumes() {
  volumes="
           -v $HOME/.ssh:${DOCKER_HOME}/.ssh \
           -v $HOME/.zsh_history:${DOCKER_HOME}/.zsh_history \
           -v /tmp/core:/tmp/core \
           -v /proc/sys/kernel/core_pattern:/tmp/core_pattern:rw \
           -v /media:/media \
           -v /private:/private \
           -v /tmp/.ssh-agent-$USER:/tmp/.ssh-agent-$USER \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /dev/input:/dev/input"

  volumes="${volumes} -v ${LOCAL_DIR}:/CORL_root"

  echo "${volumes}"
}

function get_port() {
  read lower_port upper_port < /proc/sys/net/ipv4/ip_local_port_range

  range=$1

  local success=false

  for ((port = lower_port; port <=  upper_port; port += $range)); do
    success=true
    for ((i=0; i< range; i++)); do
      netstat -antl | grep $(expr $port + $i) 2>/dev/null >/dev/null && success=false && break
    done
    if [ $success = true ]; then
      for ((i=0; i < range; i++)); do
        echo $(expr $port + $i)
      done
      break
    fi
  done
}

function map_ports() {
  local ports=("$@")
  local port_num=${#ports[*]}
  local success=true
  for ((i = 0; i < ${port_num}; i++)); do
    netstat -antl | grep ${ports[${i}]} 2>/dev/null >/dev/null && success=false && break
  done
  if [ $success = true ]; then
    local avaliable_ports=("$@")
  else
    local avaliable_ports=($(get_port ${port_num}))
  fi
  for ((i = 0; i < ${port_num}; i++)); do
    echo "-p ${avaliable_ports[${i}]}:${ports[${i}]} "
  done
}

function check_port() {
    docker port ${DOCKER_NAME} | sed "s/6080[^:]*/ssh/" | sed "s/6070[^:]*/simulation_world/"
}

function local_envs() {
    envs="--runtime nvidia"
    echo "${envs}"
}

docker ps -a --format "{{.Names}}" | grep "${DOCKER_NAME}" 1>/dev/null
if [ $? == 0 ]; then
docker stop ${DOCKER_NAME} 1>/dev/null
docker rm -f ${DOCKER_NAME} 1>/dev/null
fi

mkdir -p /tmp/.ssh-agent-$USER 2>&1 >/dev/null

USER_ID=$(id -u) 
GRP=$(id -g -n) 
GRP_ID=$(id -g) 
LOCAL_HOST=$(hostname) 
DOCKER_HOME="/home/$USER" 
if [ "$USER" == "root" ]; then
  DOCKER_HOME="/root"
fi

eval docker create -it \
      --name ${DOCKER_NAME} \
      -e DOCKER_USER=$USER \
      -e USER=$USER \
      -e DOCKER_USER_ID=$USER_ID \
      -e DOCKER_GRP=$GRP \
      -e DOCKER_GRP_ID=$GRP_ID \
      -e DOCKER_HOME=$DOCKER_HOME \
      -e PYTHONPATH=. \
      -e ENV=DEV \
      $(local_volumes) \
      --ulimit core=-1 \
      --dns=114.114.114.114 \
      --add-host CORL_docker:127.0.0.1 \
      --add-host ${LOCAL_HOST}:127.0.0.1 \
      --hostname in_CORL_docker \
      -v ${DOCKER_PATH}/entrypoint.sh:/tmp/entrypoint.sh \
      --entrypoint /tmp/entrypoint.sh \
      -v /etc/localtime:/etc/localtime:ro \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /usr/bin/docker:/usr/bin/docker \
      --device /dev/snd \
      -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
      -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
      $(local_envs) \
      $IMG /bin/bash

echo "docker created"
docker cp -L ~/.gitconfig ${DOCKER_NAME}:${DOCKER_HOME}/.gitconfig
docker start ${DOCKER_NAME}
echo "docker started"
# check_port
docker exec ${DOCKER_NAME} /bin/bash -c "ln -s -f /CORL_root/CORL /"
docker exec ${DOCKER_NAME} chown ${USER_ID}:${GRP_ID} /CORL

