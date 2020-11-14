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


# Scan for critical security vulnerabilities in openebs
# container images using trivy. 

usage()
{
	echo "Usage: $0 <release tag> [<RC>]"
	exit 1
}

if [ $# -lt 1 ]; then
	usage
fi


RELEASE_TAG=${1#v}

RC=""
if [ $# -eq 2 ]; then
  RC="-$2"
fi

XC_ARCH=$(go env GOARCH)

pull_image()
{
  IMG=$1
  TAG=$2
  if [[ $IMG =~ ^# ]]; then
    echo "Skipping $IMG:$TAG"
  else
    echo "Pulling ${IMG}-${XC_ARCH}:${TAG}"
    docker pull ${IMG}-${XC_ARCH}:${TAG}
    docker pull quay.io/${IMG}-${XC_ARCH}:${TAG}
    if [ "amd64" == "${XC_ARCH}" ];
    then
      docker pull quay.io/${IMG}:${TAG}
    fi
  fi
}

OIMGLIST=$(cat  openebs-images.txt | grep -v "#" |tr "\n" " ")
for OIMG in $OIMGLIST
do
  pull_image ${OIMG} ${RELEASE_TAG}${RC}
done

#Images that do not follow the openebs release version
FIMGLIST=$(cat  openebs-custom-tag-images.txt | grep -v "#" |tr "\n" " ")
for FIMG in $FIMGLIST
do
  FIMAGE=$(echo $FIMG | cut -d':' -f 1)
  FTAG=$(echo $FIMG | cut -d':' -f 2)
  pull_image "${FIMAGE}" "${FTAG}${RC}"
done
