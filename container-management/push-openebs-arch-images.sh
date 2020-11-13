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

multi-arch-sync()
{
  IMG=$1
  TAG=$2
  if [[ $IMG =~ ^# ]]; then
    echo "Skipping $IMG:$TAG"
  else
    echo "Syncing $IMG"
    DIMAGE="$IMG" DTAG="$TAG" ./sync-arch-image.sh
  fi
}

OIMGLIST=$(cat  openebs-images.txt | grep -v "#" |tr "\n" " ")
for OIMG in $OIMGLIST
do
  multi-arch-sync ${OIMG} ${RELEASE_TAG}${RC}
done

#Images that do not follow the openebs release version
FIMGLIST=$(cat  openebs-custom-tag-images.txt | grep -v "#" |tr "\n" " ")
for FIMG in $FIMGLIST
do
  IMAGE=$(echo $FIMG | cut -d':' -f 1)
  TAG=$(echo $FIMG | cut -d':' -f 2)
  multi-arch-sync "${IMAGE}" "${TAG}${RC}"
done
