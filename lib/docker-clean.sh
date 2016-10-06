#!/bin/bash
echo "Removing images with name <none>..."
docker rmi `docker images | grep none | awk '{print $3}'`;

echo "Removing unused containers..."
docker rm `docker ps -a | grep Exited | awk '{print $1}'`;
docker rm `docker ps -a | grep Created | awk '{print $1}'`;
docker rm `docker ps -a | grep Dead | awk '{print $1}'`;

echo "Cleaning... volumes"
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro -v /var/lib/docker:/var/lib/docker martin/docker-cleanup-volumes