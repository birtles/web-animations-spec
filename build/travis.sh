#!/bin/bash

function error_exit
{
  echo -e "\e[01;31m$1\e[00m" 1>&2
  exit 1
}

grunt build || error_exit "Error building spec"

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then
  grunt publish || error_exit "Error publishing spec"

  git config --global user.name "$COMMIT_USER (via Travis CI)"
  git config --global user.email "$COMMIT_EMAIL"

  grunt upload --gh-pages-message '$TRAVIS_COMMIT_MSG' || "Error uploading to gh-pages branch"
fi
