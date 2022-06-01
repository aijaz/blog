#!/bin/bash

cd /home/aijaz/aijaz

# via https://stackoverflow.com/a/3278427/7221535

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    exit 0
elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
    git pull
    cd site
    source venv/bin/activate
    make publishOnServer
elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
    exit 1
else
    echo "Diverged"
    exit 1
fi
