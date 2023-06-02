#export IMG=pwh12/offlinerl:latest 
if [ -z $DOCKER_NAME ]; then
  DOCKER_NAME="${USER}_offlinerl_dev"
fi
export DOCKER_NAME
export IMG=offlinerl/offlinerl_dev:latest
