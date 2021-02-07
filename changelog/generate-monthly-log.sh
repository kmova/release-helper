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
	echo "Usage: $0 <release branch>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

REL_BRANCH=$1

CHANGE_LOG="CHANGE_LOG_${REL_BRANCH}.md"
COMMITTER_LOG="COMMITTERS_${REL_BRANCH}.md"

rm -rf ${CHANGE_LOG}
rm -rf ${COMMITTER_LOG}

mkdir -p repos

setup_repo()
{
  REPODIR="repos/$1"

  if [[ -d $REPODIR ]]; then 
    cd $REPODIR && git pull && cd ../..
  else 
    REPOURL="https://github.com/openebs/$1"
    echo "Cloning $REPOURL into $REPODIR"
    cd repos && git clone $REPOURL && cd ..
  fi 

  cd $REPODIR && \
 git remote set-url --push origin no_push && \
 git remote -v && \
 cd ../..

}

change_log()
{
  setup_repo $1
  echo "==changelog for openebs/$1 ===" >> ${CHANGE_LOG}
  CHANGE_LOG_REPO="$1_${CHANGE_LOG}"
  rm -rf ${CHANGE_LOG_REPO}
  cd repos/$1
  git pull
  git checkout $2
  git pull
  git log --pretty=format:'-TPL- %s %cs (%h) (@%an)' --date=short  --since="15 dec 2020"  >> ../../${CHANGE_LOG_REPO}
  git log --pretty=format:'(@%an)' --date=short  --since="15 dec 2020"  >> ../../${COMMITTER_LOG}
  cd ../..
  sed -i '' -e "s/-TPL-/- [$1] /g" ${CHANGE_LOG_REPO}
  cat ${CHANGE_LOG_REPO} | sort  >> ${CHANGE_LOG}
  rm -rf ${CHANGE_LOG_REPO}
  echo $'\n' >> ${CHANGE_LOG}
}



REPO_LIST=$(cat openebs-repos.txt | grep -v "#" |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    change_log ${REPO} ${REL_BRANCH}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
change_log linux-utils master
change_log node-disk-manager v1.1.x
change_log zfs-localpv v1.3.x
change_log e2e-tests master
change_log openebs-docs master
change_log openebs master
change_log monitor-pv master
change_log Mayastor develop
change_log rawfile-localpv master
change_log charts master
change_log charts gh-pages
change_log website refactor-to-ghost-and-gatsby
change_log performance-benchmark master
change_log dynamic-nfs-provisioner master
change_log lvm-localpv master


committer_map()
{
  FILE=$1

  #Maintainers
  sed -i '' -e 's/@Kiran Mova/@kmova/g' ${FILE}
  sed -i '' -e 's/@Vishnu Itta/@vishnuitta/g' ${FILE}
  sed -i '' -e 's/@Jeffry Molanus/@gila/g' ${FILE}
  sed -i '' -e 's/@Karthik Satchitanand/@ksatchit/g' ${FILE}
  sed -i '' -e 's/@Murat Karslioglu/@muratkars/g' ${FILE}
  sed -i '' -e 's/@Michael Fornaro/@xUnholy/g' ${FILE}
  sed -i '' -e 's/@MIℂHΛΞL FѲRИΛRѲ/@xUnholy/g' ${FILE}
  sed -i '' -e 's/@Peeyush Gupta/@Pensu/g' ${FILE}

  #Reviewers
  sed -i '' -e 's/@mayank/@mynktl/g' ${FILE}
  sed -i '' -e 's/@Mayank/@mynktl/g' ${FILE}
  sed -i '' -e 's/@sai chaithanya/@mittachaitu/g' ${FILE}
  sed -i '' -e 's/@Payes Anand/@payes/g' ${FILE}
  sed -i '' -e 's/@Utkarsh Mani Tripathi/@utkarshmani1997/g' ${FILE}
  sed -i '' -e 's/@shubham/@shubham14bajpai/g' ${FILE}
  sed -i '' -e 's/@Shubham Bajpai/@shubham14bajpai/g' ${FILE}
  sed -i '' -e 's/@Prateek Pandey/@prateekpandey14/g' ${FILE}
  sed -i '' -e 's/@Ashutosh Kumar/@sonasingh46/g' ${FILE}
  sed -i '' -e 's/@Pawan Prakash Sharma/@pawanpraka1/g' ${FILE}
  sed -i '' -e 's/@Pawan/@pawanpraka1/g' ${FILE}
  sed -i '' -e 's/@Akhil Mohan/@akhilerm/g' ${FILE}
  sed -i '' -e 's/@Aman Gupta/@w3aman/g' ${FILE}
  sed -i '' -e 's/@Filippo Bosi/@filippobosi/g' ${FILE}
  sed -i '' -e 's/@Amrish Kushwaha/@IsAmrish/g' ${FILE}
  sed -i '' -e 's/@isamrish/@IsAmrish/g' ${FILE}
  sed -i '' -e 's/@giri/@gprasath/g' ${FILE}
  sed -i '' -e 's/@Ranjith R/@ranjithwingrider/g' ${FILE}
  sed -i '' -e 's/@Somesh Kumar/@somesh2905/g' ${FILE}
  sed -i '' -e 's/@sathyaseelan/@nsathyaseelan/g' ${FILE}
  sed -i '' -e 's/@Antonio Carlini/@AntonioCarlini/g' ${FILE}
  sed -i '' -e 's/@Blaise Dias/@blaisedias/g' ${FILE}
  sed -i '' -e 's/@Evan Powell/@epowell101/g' ${FILE}
  sed -i '' -e 's/@Glenn Bullingham/@GlennBullingham/g' ${FILE}
  sed -i '' -e 's/@Jan Kryl/@jkryl/g' ${FILE}
  sed -i '' -e 's/@Jonathan Teh/@jonathan-teh/g' ${FILE}
  sed -i '' -e 's/@yannis218/@yannis218/g' ${FILE}
  sed -i '' -e 's/@Shashank Ranjan/@shashank855/g' ${FILE}
  sed -i '' -e 's/@Tiago Castro/@tiagolobocastro/g' ${FILE}
  sed -i '' -e 's/@Ana Hobden/@Hoverbear/g' ${FILE}
  sed -i '' -e 's/@Mehran Kholdi/@SeMeKh/g' ${FILE}
  sed -i '' -e 's/@Mikhail Tcymbaliuk/@mtzaurus/g' ${FILE}
  sed -i '' -e 's/@Michael Tsymbalyuk/@mtzaurus/g' ${FILE}
  sed -i '' -e 's/@Paul Yoong/@paulyoong/g' ${FILE}
  sed -i '' -e 's/@Antonin Kral/@bobek/g' ${FILE}
  sed -i '' -e 's/@Arne Rusek/@arne-rusek/g' ${FILE}
  sed -i '' -e 's/@Giridharaprasad/@gprasath/g' ${FILE}
  sed -i '' -e 's/@nareshdesh/@nareshdesh/g' ${FILE}
  sed -i '' -e 's/@mahao/@allenhaozi/g' ${FILE}
  sed -i '' -e 's/@praveengt/@praveengt/g' ${FILE}

  #Contributors -  Community Bridge
  sed -i '' -e 's/@Harsh Thakur/@harshthakur9030/g' ${FILE} 
  sed -i '' -e 's/@vaniisgh/@vaniisgh/g' ${FILE}

  #Contributors - via Hacktoberfest 2020
  sed -i '' -e 's/@Naveenkhasyap/@Naveenkhasyap/g' ${FILE}
  sed -i '' -e 's/@Aswin Gopinathan/@infiniteoverflow/g' ${FILE}
  sed -i '' -e 's/@Siddharth Mishra/@Hard-Coder05/g' ${FILE}
  sed -i '' -e 's/@Debojyoti Chakraborty/@sparkingdark/g' ${FILE}
  sed -i '' -e 's/@Prakhar Gurunani/@prakhargurunani/g' ${FILE}
  sed -i '' -e 's/@Gagandeep Singh/@codegagan/g' ${FILE}
  sed -i '' -e 's/@Saloni Goyal/@salonigoyal2309/g' ${FILE}
  sed -i '' -e 's/@Aman Singh/@Aman1440/g' ${FILE}
  sed -i '' -e 's/@harikrishnajiju/@harikrishnajiju/g' ${FILE}
  sed -i '' -e 's/@Vijay Jangra/@vijay5158/g' ${FILE}
  sed -i '' -e 's/@PRAKHAR SHREYASH/@prakharshreyash15/g' ${FILE}
  sed -i '' -e 's/@Sudhin MN/@sudhinm/g' ${FILE}
  sed -i '' -e 's/@Taranjot Singh/@Taranzz25/g' ${FILE}
  sed -i '' -e 's/@iTechsTR/@iTechsTR/g' ${FILE}
  sed -i '' -e 's/@Ashish Maharjan/@AshishMhrzn10/g' ${FILE}
  sed -i '' -e 's/@Kung Fu Panda/@Akshay-Nagle/g' ${FILE}
  sed -i '' -e 's/@Shyam/@ShyamGit01/g' ${FILE}
  sed -i '' -e 's/@Rafael Rosseto/@rafael-rosseto/g' ${FILE}
  sed -i '' -e 's/@Michał Antropik/@Nelias/g' ${FILE}
  sed -i '' -e 's/@Shivam7-1/@Shivam7-1/g' ${FILE}
  sed -i '' -e 's/@VINAYAK MR/@vmr1532/g' ${FILE}
  sed -i '' -e 's/@Trishita/@trishitapingolia/g' ${FILE}
  sed -i '' -e 's/@hnifmaghfur/@hnifmaghfur/g' ${FILE}
  sed -i '' -e 's/@heygroot/@heygroot/g' ${FILE}
  sed -i '' -e 's/@Archit/@archit041198/g' ${FILE}
  sed -i '' -e 's/@Rajiv Singh/@iamrajiv/g' ${FILE}
  sed -i '' -e 's/@Vishal Kichloo/@kichloo/g' ${FILE}
  sed -i '' -e 's/@Karan Singh Bisht/@KaranSinghBisht/g' ${FILE}
  sed -i '' -e 's/@Lucas Queiroz/@lucasqueiroz/g' ${FILE}
  sed -i '' -e 's/@Aryan Rawlani/@aryanrawlani28/g' ${FILE}
  sed -i '' -e 's/@sabbatum/@sabbatum/g' ${FILE}
  sed -i '' -e 's/@André Aubin/@lambda2/g' ${FILE}
  sed -i '' -e 's/@Julian/@ItsJulian/g' ${FILE}
  sed -i '' -e 's/@Sumindar/@Sumindar/g' ${FILE}
  sed -i '' -e 's/@Devdutt Shenoi/@de-sh/g' ${FILE}
  sed -i '' -e 's/@Anand prabhakar/@anandprabhakar0507/g' ${FILE}

  #Contributors -  Community
  sed -i '' -e 's/@Sumit Lalwani/@slalwani97/g' ${FILE}
  sed -i '' -e 's/@Christopher J. Ruwe/@cruwe/g' ${FILE}
  sed -i '' -e 's/@Sjors Gielen/@sgielen/g' ${FILE}
  sed -i '' -e 's/@Shubham Bhardwaj/@ShubhamB99/g' ${FILE}
  sed -i '' -e 's/@GTB3NW/@GTB3NW/g' ${FILE}
  sed -i '' -e 's/@fukuta-tatsuya-intec/@fukuta-tatsuya-intec/g' ${FILE}
  sed -i '' -e 's/@mtmn/@mtmn/g' ${FILE}
  sed -i '' -e 's/@Nick Pappas/@radicand/g' ${FILE}
  sed -i '' -e 's/@Nikolay Rusinko/@nrusinko/g' ${FILE}
  sed -i '' -e 's/@Zach Dunn/@zadunn/g' ${FILE}
  sed -i '' -e 's/@wiwen/@Icedroid/g' ${FILE}
  sed -i '' -e 's/@Rahul M Chheda/@rahulchheda/g' ${FILE}
  sed -i '' -e 's/@paulyoong/@paulyoong/g' ${FILE}
  sed -i '' -e 's/@chriswldenyer/@chriswldenyer/g' ${FILE}
  sed -i '' -e 's/@Colin Jones/@cjones1024/g' ${FILE}
  sed -i '' -e 's/@Doug Hoard/@dhoard/g' ${FILE}
  sed -i '' -e 's/@Harsh Shekhar/@harshshekhar15/g' ${FILE}
  sed -i '' -e 's/@Juan Eugenio Abadie/@whoan/g' ${FILE}
  sed -i '' -e 's/@NightsWatch/@silentred/g' ${FILE}
  sed -i '' -e 's/@Tom Marsh/@tjoshum/g' ${FILE}
  sed -i '' -e 's/@Waqar Ahmed/@sonicaj/g' ${FILE}
  sed -i '' -e 's/@Akın Özer/@akin-ozer/g' ${FILE}
  sed -i '' -e 's/@Alex Perez-Pujol/@alexppg/g' ${FILE}
  sed -i '' -e 's/@anupriya0703/@anupriya0703/g' ${FILE}
  sed -i '' -e 's/@Ben Hundley/@FestivalBobcats/g' ${FILE}
  sed -i '' -e 's/@Daniel Sand/@danielsand/g' ${FILE}
  sed -i '' -e 's/@Ondrej Beluský/@zlymeda/g' ${FILE}
  sed -i '' -e 's/@Ondrej Belusky/@zlymeda/g' ${FILE}
  sed -i '' -e 's/@Aditya Vats/@avats-dev/g' ${FILE}
  sed -i '' -e 's/@Niladri Halder/@niladrih/g' ${FILE}
  sed -i '' -e 's/@hack3r-0m/@hack3r-0m/g' ${FILE}
  sed -i '' -e 's/@Eugenio A. Naselli/@shock0572/g' ${FILE}
  sed -i '' -e 's/@Mateusz Gozdek/@invidian/g' ${FILE}
  sed -i '' -e 's/@filip-lebiecki/@filip-lebiecki/g' ${FILE}
  sed -i '' -e 's/@FeynmanZhou/@FeynmanZhou/g' ${FILE}
  sed -i '' -e 's/@Nofar Spalter/@Nofar Spalter/g' ${FILE}
  sed -i '' -e 's/@Richard Arends/@Mosibi/g' ${FILE}
  sed -i '' -e 's/@Sebastien Dionne/@survivant/g' ${FILE}
  sed -i '' -e 's/@ajeet_rai/@ajeet_rai/g' ${FILE}
  sed -i '' -e 's/@kaushikp13/@kaushikp13/g' ${FILE}

  FILE=""
}

committer_map ${CHANGE_LOG}
committer_map ${COMMITTER_LOG}


sed -i '' -e 's/)(/),(/g' ${COMMITTER_LOG}
sed -i '' -e $'s/,/\\\n/g' ${COMMITTER_LOG}
sort ${COMMITTER_LOG} | uniq
