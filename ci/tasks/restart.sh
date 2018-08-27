#!/usr/bin/env bash
set -e

#clone the repo
git clone https://$PASSWORD@github.com/s1p-demo/concourse-spring-music.git

#create aws credentials file so we can pull files
mkdir ~/.aws
cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id=$S3_ACCESS_KEY_ID
aws_secret_access_key=$S3_SECRET_ACCESS_KEY
EOF

#pull the current color from S3
aws s3 cp s3://$S3_BUCKET/$S3_BLUE_GREEN_FILE color

#meow the color
color=`cat color`

# make it colorful!
cd concourse-spring-music
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
  echo "green" > ../../color
else
  echo "turning banner blue"
  ./makeItBlue.sh
  echo "blue" > ../../color
fi

#push the color change back to S3
aws s3 cp ../../color s3://$S3_BUCKET/$S3_BLUE_GREEN_FILE
