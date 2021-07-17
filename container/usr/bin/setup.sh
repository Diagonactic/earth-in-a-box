#!/bin/bash

UD="$1" # User ID
GD="$2" # Group ID
UNAME="$3" # User Name

# Group ID / User ID has to match; we're going to replace the group file on start
cat /etc/group | grep -Pq '\:'$GD'\:'
if [[ $? -ne 0 ]]; then
    groupadd -g $GD users
fi

cat /etc/passwd | grep -Pq '\:'$UD'\:'
if [[ $? -ne 0 ]]; then
    useradd -md /home/"${UNAME}" -g $GD "$UNAME"
fi
