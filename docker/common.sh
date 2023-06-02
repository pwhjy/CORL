#export IMG=pwh12/offlinerl:latest 
if [ -z $DOCKER_NAME ]; then
  DOCKER_NAME="${USER}_corl_dev"
fi
export DOCKER_NAME
export IMG=corl/corl_dev:latest
