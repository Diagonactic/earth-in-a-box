#!/bin/bash
function die {
    echo "$1"
    exit 2
}
function diemap {
    die "Cannot find $1, make sure to create the container with that volume mapped!"    
}
echo "Google Earth Pro ... in a box"
echo "Home Directory: $HOME"
echo "User: '$(id -un)' ($(id -u))"
echo "Group: '$(id -gn)' ($(id -g))"
echo "Home: '$HOME'"
echo "Display: '$DISPLAY'"
if [[ ! -e "$HOME/.Xauthority" ]]; then diemap "$HOME/.Xauthority"; fi

if [[ ! -e "/tmp/.X11-unix" ]]; then diemap "/tmp/.X11-unix"; fi

rm -rf /home/acousticiris/.googleearth/instance-running-lock

export QT_GRAPHICSSYSTEM="native"

/opt/google/earth/pro/googleearth-bin