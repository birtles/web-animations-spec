#!/bin/bash

function error_exit
{
  echo -e "\e[01;31m$1\e[00m" 1>&2
  exit 1
}

grunt build || error_exit "Error building spec"

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then
  grunt publish || error_exit "Error publishing spec"

  echo "$TRAVIS_COMMIT_RANGE"
  echo "$TRAVIS_REPO_SLUG"
  echo "$COMMIT_USER"
  echo "$COMMIT_EMAIL"

  git config --global user.name "webanimbot"
  git config --global user.email "webanimbot@gmail.com"

  grunt upload --gh-pages-message "$TRAVIS_COMMIT_MSG" || "Error uploading to gh-pages branch"
fi
