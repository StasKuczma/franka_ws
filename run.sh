#!/bin/bash
IMAGE_NAME="franka_ws:latest"
CONTAINER_NAME="franka_ws"

xhost +local:root
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi
docker stop $CONTAINER_NAME || true && docker rm $CONTAINER_NAME || true
docker run -it \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --volume="/dev:/dev" \
    --volume="$PWD/src:/catkin_ws/src/external" \
    --privileged \
    --network=host \
    --name="$CONTAINER_NAME" \
    $IMAGE_NAME \
    /bin/bash
