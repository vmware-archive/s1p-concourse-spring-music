#!/usr/bin/env bash
set -e

#clone the repo
git clone https://$PASSWORD@$GIT_REPO_URL

# make it colorful!
cd s1p-concourse-spring-music

#meow the color
color=`cat color`

cd bin

#add git config so it stops complaining about not having user info
git config --global user.email "bbyers@pivotal.io"
git config --global user.name "Concourse"
git config --global push.default matching

#change the color using the scripts
echo "Current color: "$color
if [ "$color" == "blue" ]; then
  echo "turning banner green"
  ./makeItGreen.sh
else
  echo "turning banner blue"
  ./makeItBlue.sh
fi
