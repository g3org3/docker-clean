#!/bin/bash

clean_images() {
  echo "Removing images with name <none> ...";
  docker rmi `docker images | grep none | awk '{print $3}'`;
  return 0;
}

clean_containers() {
  echo "Removing unused containers...";
  docker rm `docker ps -a | grep Exited | awk '{print $1}'`;
  docker rm `docker ps -a | grep Created | awk '{print $1}'`;
  docker rm `docker ps -a | grep Dead | awk '{print $1}'`;
  return 0;
}

clean_volumes() {
  echo "Cleaning... volumes";
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro -v /var/lib/docker:/var/lib/docker martin/docker-cleanup-volumes;
  return 0;
}

clean_silent_containers() {
  echo "  * Removing images with name <none> ...";
  docker rmi `docker images | grep none | awk '{print $3}'` 2> /dev/null;
}

clean_silent_images() {
  echo "  * Removing unused containers ...";
  docker rm `docker ps -a | grep Exited | awk '{print $1}'` 2> /dev/null;
  docker rm `docker ps -a | grep Created | awk '{print $1}'` 2> /dev/null;
  docker rm `docker ps -a | grep Dead | awk '{print $1}'` 2> /dev/null;
}

clean_silent_volumes() {
  echo "  * Cleaning volumes with martin/docker-cleanup-volumes ...";
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro -v /var/lib/docker:/var/lib/docker martin/docker-cleanup-volumes | grep delete 2> /dev/null;
  echo " Done.";
  echo "";
  return 0;
}

usage() {
  echo -e "\n USAGE:";
  echo -e "  docker-clean [options]";
  echo -e "\n Options";
  echo -e "   -v       \tDisplay version";
  echo -e "   --con, -c\tRemove exited containers";
  echo -e "   --vol    \tClean up volumes";
  echo -e "   --images, -i\tRemove all images tagged with <none>";
  echo -e "   --all, -a\tRemove all of the above";
  echo "";
}

clean_silent() {
  clean_silent_containers;
  clean_silent_images;
  clean_silent_volumes;
}

clean_all() {
  clean_containers;
  clean_images;
  clean_volumes;
}

if [[ "$1" = "-v" ]]; then
  echo "version: v0.0.5";
elif [[ "$1" = "-a" || "$1" = "--all" ]]; then
  clean_silent;
elif [[ "$1" = "-c" || "$1" = "--con" ]]; then
  clean_silent_containers;
elif [[ "$1" = "-i" || "$1" = "--images" ]]; then
  clean_silent_images;
elif [[ "$1" = "-x" || "$1" = "--vol" ]]; then
  clean_silent_volumes;
elif [[ "$1" = "-av" || "$1" = "--all" ]]; then
  clean_all;
elif [[ "$1" = "-cv" || "$1" = "--con" ]]; then
  clean_containers;
elif [[ "$1" = "-iv" || "$1" = "--images" ]]; then
  clean_silent_images;
elif [[ "$1" = "-xv" || "$1" = "--vol" ]]; then
  clean_volumes;
else
  usage;
fi
