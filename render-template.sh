#!/bin/bash

if [ -z "$1" ]
  then
    echo "Usage:"
    echo "  render-template.sh <tag>"
    exit 1
fi

echo "FROM bde2020/spark-base:${1}" > Dockerfile
cat Dockerfile.template >> Dockerfile
