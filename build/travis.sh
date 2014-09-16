#!/bin/bash

function error_exit
{
  echo -e "\e[01;31m$1\e[00m" 1>&2
  exit 1
}

grunt build || error_exit "Error building spec"

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then
  grunt publish || error_exit "Error publishing spec"

  echo "$REPO.git"
  echo "$TRAVIS_COMMIT_RANGE"
  echo "$TRAVIS_REPO_SLUG"

  git remote set-url origin $REPO.git
  git config --global user.name "webanimbot"
  git config --global user.email "webanimbot@gmail.com"

  # Git authentication
  #
  # The following is based on code from:
  #
  #   https://gist.github.com/douglasduteil/5525750
  #   http://blog.yasuoza.com/2014/01/13/octopress-plus-github-pages-plus-travis/
  if [ -z "$id_rsa_{1..24}" ]; then echo 'No $id_rsa_{1..24} found !' ; exit 1; fi
  echo -n $id_rsa_{1..24} >> ~/.ssh/travis_rsa_64
  base64 --decode --ignore-garbage ~/.ssh/travis_rsa_64 > ~/.ssh/id_rsa
  chmod 600 ~/.ssh/id_rsa
  echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

  grunt upload --gh-pages-message "$TRAVIS_COMMIT_MSG" || "Error uploading to gh-pages branch"
fi
