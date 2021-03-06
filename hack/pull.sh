#!/bin/sh

set -e

repository="$1"

grounds_exec_images() {
    echo $(docker search $repository | grep "$repository/exec-" | awk -F ' ' '{ print $1 }')
}

if [ -z $repository ]; then
    echo "usage: pull REPOSITORY TAG"
    return
fi

for image in $(grounds_exec_images); do
    docker pull "$image"
done
