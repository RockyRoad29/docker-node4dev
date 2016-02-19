#!/bin/bash -e
# Extracts contents of mountable volumes from image
# 
# If needed provide username (build ARG)

USER1=${1-user1}

# you need a container to access its filesystem
echo "Generating a fresh temporary container ..."
docker run rockyroad/node4dev
# get its id
container=`docker ps -lq`

# extract needed contents 
echo "Extracting user home in $USER1/..." 
docker cp $container:/home/$USER1 .
echo "Extracting npm cache in cache/npm ..."
docker cp $container:/var/local/cache/npm cache

# delete container on success (-e flag on)
echo "Removing temporary container ..."
docker rm $container

echo "Mounts contents successfully extracted "
