#!/usr/bin/env bash
set -e

version=`cat version/number`

echo "Renaming release-candidate to final build"
cp release-candidate/${base_name}*.jar final-dir/${base_name}-${version}.jar
