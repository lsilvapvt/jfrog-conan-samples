#!/bin/bash

set -e

# git clone https://github.com/lsilvapvt/jfrog-conan-samples.git
# cd jfrog-conan-samples/libraries/custom/hellopkg

#define all PIPELINE_PARAM_* parameters below in the Jenkins pipeline config 
export RT_USERNAME=$PIPELINE_PARAM_USERNAME
export RT_PASSWORD=$PIPELINE_PARAM_PASSWORD
export RT_CONAN_REPO_URL=$PIPELINE_PARAM_CONAN_REPO_URL  # e.g. https://myrt.com/artifactory/api/conan/conan-repo
export RT_API_URL=$PIPELINE_PARAM_RT_API_URL # e.g. https://myrt.com/artifactory/api/build

export MY_BUILD_NAME=$JOB_BASE_NAME
export MY_BUILD_NUMBER=$BUILD_NUMBER
export MY_BUILD_TIMESTAMP=$(date +%s)
export MY_BUILD_STARTDATE=$(date --utc "+%FT%T.%N" | sed -r 's/[[:digit:]]{6}$/Z/')
# extract package version from conanfile.py
export MY_PKG_VERSION=$(cat conanfile.py | cat conanfile.py | sed -n -e '/version \=/ s/.*\= *//p' | tr -d '"')

# prepare artifactory config 
echo "" > ~/.conan/artifacts.properties
echo "artifact_property_build.name=${MY_BUILD_NAME}" >> ~/.conan/artifacts.properties
echo "artifact_property_build.number=${MY_BUILD_NUMBER}" >> ~/.conan/artifacts.properties
echo "artifact_property_build.timestamp=${MY_BUILD_TIMESTAMP}" >> ~/.conan/artifacts.properties

conan profile new default --detect
conan profile update settings.compiler.libcxx=libstdc++11 default

# conan add remote 
conan remote add rtsaas ${RT_CONAN_REPO_URL}
conan user -r rtsaas ${RT_USERNAME} -p ${RT_PASSWORD}
export CONAN_REVISIONS_ENABLED=1

export CONAN_TRACE_FILE=/tmp/traces.log
export BUILD_INFO_FILE=/tmp/build_info.json
rm ${CONAN_TRACE_FILE}
rm ${BUILD_INFO_FILE}

conan create .

conan upload --all -r=rtsaas -c hellopkg/${MY_PKG_VERSION}

conan_build_info ${CONAN_TRACE_FILE} --output ${BUILD_INFO_FILE}

# add build name, number and started to build info 
cat ${BUILD_INFO_FILE} | \
    jq --arg name    "${MY_BUILD_NAME}" \
       --arg number  "${MY_BUILD_NUMBER}" \
       --arg started "${MY_BUILD_STARTDATE}"  \
       '. + {name: $name,number: $number,started: $started}' > ./build_info.json 

curl -X PUT -u${RT_USERNAME}:${RT_PASSWORD} \
       -H "Content-type: application/json" \
       -T ./build_info.json \
       ${RT_API_URL}

export CONAN_TRACE_FILE=
