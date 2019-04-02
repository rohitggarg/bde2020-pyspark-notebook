#!/bin/bash

BRANCH=`git rev-parse --abbrev-ref HEAD`
if [ -z "$BRANCH" ]
  then
    echo "Not in version control"
    exit 1
fi

if [ "$BRANCH" != "master" ]
  then
    echo "Create new tags from master only"
    exit 2
fi
if [ -z "$1" ]
  then
    echo "Specify the branch to create"
    exit 1
fi

NEEDED=$1
echo "On branch -> $BRANCH"
echo "Making branch -> $NEEDED"
git branch $NEEDED && git checkout $NEEDED

echo "FROM bde2020/spark-base:${NEEDED}" > Dockerfile
cat Dockerfile.template >> Dockerfile

git add Dockerfile
git commit -m "Set base version in dockerfile"

git push -f origin $NEEDED
git checkout master
