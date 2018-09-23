#!/usr/bin/env bash
set -e

#clone the repo
git clone https://$PASSWORD@$GIT_REPO_URL repo

# make it colorful!
cd repo
cd bin

#add git config so it stops complaining about not having user info
git config --global user.email "bbyers@pivotal.io"
git config --global user.name "Concourse"
git config --global push.default matching

echo "turning banner green"
./makeItGreen.sh
