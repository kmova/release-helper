#!/bin/bash

# Copyright 2020 The OpenEBS Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [ -z ${DIMAGE} ];
then
  echo "Error: DIMAGE is not specified";
  exit 1
fi

if [ -z ${DTAG} ];
then
  echo "Error: DTAG is not specified";
  exit 1
fi


IMAGEID=$(docker images -q ${DIMAGE}:${DTAG} )
echo "${DIMAGE}:${DTAG} -> $IMAGEID"
if [ -z ${IMAGEID} ];
then
  echo "Error: unable to get IMAGEID for ${DIMAGE}:${DTAG}";
  exit 1
fi

XC_ARCH=$(go env GOARCH)
if [ -z ${XC_ARCH} ];
then
  echo "Error: unable to get XC_ARCH of current host";
  exit 1
fi


echo "Sync ${DIMAGE}-${XC_ARCH}:${DTAG} using multi arch image to docker and quay"


function TagAndPushImage() {
  if [ -z ${TRAVIS_TAG} ];
  then
    echo "Skip pushing as this($TRAVIS_BRANCH) is not a release branch.";
  else  
    IMAGE_URI="$1"
    docker tag ${IMAGEID} ${IMAGE_URI};
    echo " push ${IMAGE_URI}";
    docker push ${IMAGE_URI};
  fi
}


if [ ! -z "${DNAME}" ] && [ ! -z "${DPASS}" ];
then
  docker login -u "${DNAME}" -p "${DPASS}";
  # Push ARCH image to docker
  TagAndPushImage ${DIMAGE}-${XC_ARCH}:${DTAG}
else
  echo "No docker credentials provided. Skip uploading ${DIMAGE}-${XC_ARCH}:${DTAG} to docker hub";
fi;

# Push ci image to quay.io for security scanning
if [ ! -z "${QNAME}" ] && [ ! -z "${QPASS}" ];
then
  docker login -u "${QNAME}" -p "${QPASS}" quay.io;

  TagAndPushImage "quay.io/${DIMAGE}-${XC_ARCH}:${DTAG}"

  if [ "amd64" == "${XC_ARCH}" ] ;
  then
    TagAndPushImage "quay.io/${DIMAGE}:${DTAG}"
  fi;
else
  echo "No docker credentials provided. Skip uploading ${DIMAGE}-${XC_ARCH}:${DTAG} to quay";
fi;
