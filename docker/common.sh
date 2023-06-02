#export IMG=pwh12/offlinerl:latest 
if [ -z $DOCKER_NAME ]; then
  DOCKER_NAME="${USER}_CORL_dev"
fi
export DOCKER_NAME
export IMG=CORL/CORL_dev:latest
