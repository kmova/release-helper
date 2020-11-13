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

usage()
{
	echo "Usage: $0 <release tag> [<RC>]"
	exit 1
}

if [ $# -lt 1 ]; then
	usage
fi

# remove the v prefix from the release tag if it exists
RELEASE_TAG=${1#v}

RC=""
if [ $# -eq 2 ]; then
  RC="-$2"
fi

XC_ARCH=$(go env GOARCH)

IMAGE_LIST=$(cat openebs-images.txt | grep -v "#" |tr "\n" " ")
for IMAGE in $IMAGE_LIST
do
  ./check-docker-img-tag.sh "${IMAGE}" "${RELEASE_TAG}${RC}"
done

# check images having fixed tags in docker hub
CUSTOM_TAGGED_LIST=$(cat openebs-custom-tag-images.txt | grep -v "#" |tr "\n" " ")
for IMAGE_TAG in $CUSTOM_TAGGED_LIST
do
  IMAGE=$(echo $IMAGE_TAG | cut -d':' -f 1)
  TAG=$(echo $IMAGE_TAG | cut -d':' -f 2)
  ./check-docker-img-tag.sh "${IMAGE}" "${TAG}${RC}"
done

echo
echo "Checking for arch(${XC_ARCH}) specific images"
echo

IMAGE_LIST=$(cat openebs-images.txt | grep -v "#" |tr "\n" " ")
for IMAGE in $IMAGE_LIST
do
  ./check-docker-img-tag.sh "${IMAGE}-${XC_ARCH}" "${RELEASE_TAG}${RC}"
done

# check images having fixed tags in docker hub
CUSTOM_TAGGED_LIST=$(cat openebs-custom-tag-images.txt | grep -v "#" |tr "\n" " ")
for IMAGE_TAG in $CUSTOM_TAGGED_LIST
do
  IMAGE=$(echo $IMAGE_TAG | cut -d':' -f 1)
  TAG=$(echo $IMAGE_TAG | cut -d':' -f 2)
  ./check-docker-img-tag.sh "${IMAGE}-${XC_ARCH}" "${TAG}${RC}"
done


