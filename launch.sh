#!/bin/bash
# usage: ./launch.sh <directory>.
# 
# Launches the fse-2020-perses-artifacts image, mounts <directory> under /outside.
# If <directory> does not exist, creates it.  Also ensures that it is
# chmod(777) to ensure that the docker user can write to it.
DIRECTORY=$(realpath $1)
mkdir -p ${DIRECTORY}
chmod 777 ${DIRECTORY}

docker run --rm --name "fse-2020-perses-artifacts" -it -v ${DIRECTORY}:/outside fse-2020-perses-artifacts
