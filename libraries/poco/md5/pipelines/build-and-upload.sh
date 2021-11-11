#!/bin/bash

set -ex

# git clone https://github.com/lsilvapvt/jfrog-conan-samples.git
# cd jfrog-conan-samples/libraries/custom/hellopkg

#define all PIPELINE_PARAM_* parameters below in the Jenkins pipeline config 
export RT_USERNAME=$PIPELINE_PARAM_USERNAME
export RT_PASSWORD=$PIPELINE_PARAM_PASSWORD
export RT_CONAN_REPO_URL=$PIPELINE_PARAM_CONAN_REPO_URL  # e.g. https://myrt.com/artifactory/api/conan/conan-repo
export RT_URL=$PIPELINE_PARAM_RT_URL # e.g. https://myartifactory.com
export RT_API_URL=$PIPELINE_PARAM_RT_API_URL # e.g. https://myrt.com/artifactory/api/build

export MY_BUILD_NAME=$JOB_BASE_NAME
export MY_BUILD_NUMBER=$BUILD_NUMBER
export MY_BUILD_TIMESTAMP=$(date +%s)
export MY_BUILD_STARTDATE=$(date --utc "+%FT%T.%N" | sed -r 's/[[:digit:]]{6}$/Z/')
export MY_APP_VERSION="0.1.${MY_BUILD_TIMESTAMP}"

conan profile new default --detect
conan profile update settings.compiler.libcxx=libstdc++11 default

# conan add remote 
export CONAN_REVISIONS_ENABLED=1
conan remote add rtsaas ${RT_CONAN_REPO_URL}
conan user -r rtsaas ${RT_USERNAME} -p ${RT_PASSWORD}

export CONAN_TRACE_FILE=/tmp/traces.log
export BUILD_INFO_FILE=/tmp/build_info.json

# prepare artifactory config 
echo "" > ~/.conan/artifacts.properties
echo "artifact_property_build.name=${MY_BUILD_NAME}" >> ~/.conan/artifacts.properties
echo "artifact_property_build.number=${MY_BUILD_NUMBER}" >> ~/.conan/artifacts.properties
echo "artifact_property_build.timestamp=${MY_BUILD_TIMESTAMP}" >> ~/.conan/artifacts.properties


# prepare JFrog CLI 
jfrog config add jpd --url "RT_URL" --user "$RT_USERNAME" --password "$PIPELINE_PARAM_PASSWORD" --overwrite --interactive=false

# Build application 
mkdir build
cd build  

conan install .. --build=missing -r rtsaas
cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release
cmake --build .

./bin/md5 

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
