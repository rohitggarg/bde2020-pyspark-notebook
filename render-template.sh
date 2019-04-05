#!/bin/bash

if [ -z "$1" ]
  then
    echo "Usage:"
    echo "  render-template.sh <tag>"
    exit 1
fi

SPARK_VERSION=`echo $1 | cut -d'-' -f1`
HADOOP_VERSION=`echo $1 | cut -d'-' -f2`

cat Dockerfile.template | sed -e s/\{SPARK_VERSION\}/${SPARK_VERSION}/g | sed -e s/\{HADOOP_VERSION\}/${HADOOP_VERSION}/g > Dockerfile
