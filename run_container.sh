#!/bin/sh
echo "Run Container"
xhost + local:root

docker run \
    --name template_docker_ros \
    --privileged \
    -it \
    --rm \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    --gpus all \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/.Xauthority:/home/docker/.Xauthority \
    -v $PWD/template_pkg:/home/docker/ros_ws/src/template_pkg \
    --net host \
    --ipc host \
    template_docker_ros/ros:noetic
