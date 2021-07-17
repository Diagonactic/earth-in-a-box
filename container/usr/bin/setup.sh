#!/bin/bash

function die {
    echo "$1"
    exit 2
}

UD="$1" # User ID
GD="$2" # Group ID
UNAME="$3" # User Name
echo "Setting up USER $UNAME ($UD) for group 'users' ($GD)"

# Group ID / User ID has to match; we're going to replace the group file on start
cat /etc/group | grep -Pq '\:'$GD'\:'
if [[ $? -ne 0 ]]; then
    echo "Group with ID $GD did not exist, creating"
    groupadd -g $GD users || die $1
else
    echo "Group with ID $GD already exists in container"
fi

cat /etc/passwd | grep -Pq '\:'$UD'\:'
if [[ $? -ne 0 ]]; then
    echo "User with ID $UD did not exist, creating"
    useradd -md /home/"${UNAME}" -g $GD "$UNAME"
else
    echo "User with ID $UD already exists in container"
fi
