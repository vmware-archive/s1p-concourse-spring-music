#!/usr/bin/env bash

cp ../src/main/resources/static/css/blue-app.css ../src/main/resources/static/css/app.css
echo "blue" > ../color
git add ../color
git add ../src/main/resources/static/css/app.css
git commit -m 'making banner blue'
git push
