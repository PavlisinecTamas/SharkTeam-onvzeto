#!/bin/bash

Help() 
{
    echo "Ez a Carla-t és ROS2-t tartalmazó konténer indítását segítő script."
    echo "Használat:"
    echo "$0 KONTÉNER_NEVE [-n] [-DOCKER ARGS]"
    echo 
    echo "options:"
    echo "-h    print this help"
    echo "-n    konténer futtatása nvidia videókártyával"
    exit 1
}

intel()
{
    docker run -it "${@:2}" \
    --device=/dev/dri:/dev/dri \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/dev/dri:/dev/dri:rw" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    $1
}

nvidia()
{
    docker run -it "${@:3}" \
    --runtime=nvidia \
    --gpus all \
    --device=/dev/dri:/dev/dri \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/dev/dri:/dev/dri:rw" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    $1
}

if [ "$#" -eq 1 ] ; then
    case $1 in
        -h|--help) Help;;
        -*) Help;;
        *) intel $@; exit 0;;
    esac
fi

if [ "$#" -gt 1 ]; then
    case $2 in
        -h|--help) Help;;
        -n) nvidia $@; exit 0;;
        *) Help;;
    esac
fi 

Help