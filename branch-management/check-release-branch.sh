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
	echo "Usage: $0 [release branch]"
	echo "  Displays the presense of the provided release branch."
	echo "  Default - checks for branch named develop."
	exit 1
}

if [ $# -gt 1 ]; then
	usage
fi

if [ $# -ne 1 ]; then
	REL_BRANCH="develop"
else
	REL_BRANCH=$1
fi


REPO_LIST=$(cat  openebs-repos.txt | grep -v "#" |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    ./git-get-branch openebs/${REPO} ${REL_BRANCH}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
./git-get-branch openebs/linux-utils main
./git-get-branch openebs/api develop
./git-get-branch openebs/zfs-localpv develop
./git-get-branch openebs/lvm-localpv develop
./git-get-branch openebs/node-disk-manager develop
./git-get-branch openebs/dynamic-nfs-provisioner develop
./git-get-branch openebs/device-localpv develop
./git-get-branch openebs/Mayastor develop
./git-get-branch openebs/rawfile-localpv develop
./git-get-branch openebs/monitoring develop
./git-get-branch openebs/openebsctl develop
./git-get-branch openebs/zfs-localpv v1.9.x
./git-get-branch openebs/lvm-localpv v0.8.x
./git-get-branch openebs/node-disk-manager v1.7.x
./git-get-branch openebs/dynamic-nfs-provisioner v0.7.x
./git-get-branch openebs/openebs-k8s-provisioner v2.12.x
./git-get-branch openebs/maya v2.12.x
