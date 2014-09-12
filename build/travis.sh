#!/bin/bash

function error_exit
{
  echo -e "\e[01;31m$1\e[00m" 1>&2
  exit 1
}

grunt build || error_exit "Error building spec"

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then
  grunt publish || error_exit "Error publishing spec"
fi

# Just some debugging curiosities
pwd
echo "$TRAVIS_COMMIT_MSG"
