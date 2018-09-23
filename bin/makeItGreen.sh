#!/usr/bin/env bash

cp ../src/main/resources/static/css/green-app.css ../src/main/resources/static/css/app.css
echo "green" > ../color
git add ../color
git add ../src/main/resources/static/css/app.css
git commit -m 'making banner green'
git push
