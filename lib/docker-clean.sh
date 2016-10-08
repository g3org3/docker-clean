#!/bin/bash

clean() {
  echo "Removing images with name <none>..."
  docker rmi `docker images | grep none | awk '{print $3}'`;

  echo "Removing unused containers..."
  docker rm `docker ps -a | grep Exited | awk '{print $1}'`;
  docker rm `docker ps -a | grep Created | awk '{print $1}'`;
  docker rm `docker ps -a | grep Dead | awk '{print $1}'`;

  echo "Cleaning... volumes"
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro -v /var/lib/docker:/var/lib/docker martin/docker-cleanup-volumes
  return 0
}
clean-silent() {
  echo "";
  echo " Silent clean"
  echo "  * Removing images with name <none>..."
  docker rmi `docker images | grep none | awk '{print $3}'` 2> /dev/null;

  echo "  * Removing unused containers..."
  docker rm `docker ps -a | grep Exited | awk '{print $1}'` 2> /dev/null;
  docker rm `docker ps -a | grep Created | awk '{print $1}'` 2> /dev/null;
  docker rm `docker ps -a | grep Dead | awk '{print $1}'` 2> /dev/null;

  echo "  * Cleaning... volumes with martin/docker-cleanup-volumes"
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro -v /var/lib/docker:/var/lib/docker martin/docker-cleanup-volumes | grep delete 2> /dev/null;
  echo " Done."
  echo ""
  return 0
}


# MAIN
if [[ "$1" = "-s" ]]; then
  clean-silent
elif [[ "$1" = "-v" ]]; then
  echo -e "\n version: v0.0.3\n"
else
  clean
fi