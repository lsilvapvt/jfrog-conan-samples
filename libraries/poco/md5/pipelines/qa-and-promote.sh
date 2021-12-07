#!/bin/bash

set -ex

# git clone https://github.com/lsilvapvt/jfrog-conan-samples.git
# cd jfrog-conan-samples/libraries/custom/hellopkg

#define all PIPELINE_PARAM_* parameters below in the Jenkins pipeline config 
export RT_USERNAME=$PIPELINE_PARAM_USERNAME
export RT_PASSWORD=$PIPELINE_PARAM_PASSWORD
export RT_URL=$PIPELINE_PARAM_RT_URL # e.g. https://myartifactory.com
export RT_API_URL=$PIPELINE_PARAM_RT_API_URL # e.g. https://myrt.com/artifactory/api/build

export MY_BUILD_NAME=$JOB_BASE_NAME
export MY_BUILD_NUMBER=$BUILD_NUMBER
export MY_BUILD_TIMESTAMP=$(date +%s)
export MY_BUILD_STARTDATE=$(date --utc "+%FT%T.%N" | sed -r 's/[[:digit:]]{6}$/Z/')
export MY_APP_VERSION="0.1.${MY_BUILD_TIMESTAMP}"

# prepare JFrog CLI 
jfrog config add jpd --url "${RT_URL}" --user "${RT_USERNAME}" --password "${RT_PASSWORD}" --overwrite --interactive=false
export JFROG_CLI_BUILD_NAME=$MY_BUILD_NAME
export JFROG_CLI_BUILD_NUMBER=$MY_BUILD_NUMBER
export JFROG_CLI_BUILD_URL=$BUILD_URL

./bin/md5 

jfrog rt download ford-generic-local/services/md5/md5 

# Test version of binary here 

# If successful, promote binary/build to Prod 

# Publish build 
jfrog rt build-collect-env

jfrog rt build-publish
