#!/bin/bash

set -e

REPO=$PLUGIN_REPO
TAG=$PLUGIN_TAG
BUILDER=$PLUGIN_BUILDER
BUILDPACK=$PLUGIN_BUILDPACK
CWD=$PLUGIN_CWD
PUBLISH=$PLUGIN_PUBLISH
REGISTRY=${PLUGIN_REGISTRY:=docker.io}
USERNAME=$PLUGIN_USERNAME
PASSWORD=$PLUGIN_PASSWORD
CACHE_IMAGE=$PLUGIN_CACHE_IMAGE

# Test docker socket
if (! docker stats --no-stream &> /dev/null); then
    echo "Error connecting to docker socket.  Ensure container /var/run/docker.sock is properly mounted."; 
    exit 1;
fi

# Get first tag from array for main image
TAG_ARG=""
TAG_ARRAY=(${TAG})
PRIMARY_TAG=${TAG_ARRAY[0]}
unset 'TAG_ARRAY[0]'

# Add additional tags arguments if provided
for t in "${TAG_ARRAY[@]}"
do
    TAG_ARG+=" --tag ${REPO}:${t} "
done

# Create buildpack arguments if provided
[[ -z "${BUILDPACK}" ]] && BUILDPACK_ARG="" || BUILDPACK_ARG="--buildpack ${BUILDPACK}"

PUBLISH_ARG=""
if [[ $PUBLISH ]]; then
    docker login -u ${USERNAME} -p ${PASSWORD} ${REGISTRY}
    PUBLISH_ARG+=" --publish "

    if [[ $REPO != "${REGISTRY}"* ]]; then
        REPO="${REGISTRY}/${REPO}"
    fi

    if [[ $CACHE_IMAGE ]]; then
        if [[ $CACHE_IMAGE != "${REGISTRY}"* ]]; then
            CACHE_IMAGE="${REGISTRY}/${CACHE_IMAGE}"
        fi
        PUBLISH_ARG+=" --cache-image ${CACHE_IMAGE} "
    fi
fi

echo "Building ${REPO}:${PRIMARY_TAG} from ${CWD}"
echo 


cmd="pack build ${REPO}:${PRIMARY_TAG} --path ${CWD} --builder ${BUILDER} ${BUILDPACK_ARG} ${TAG_ARG} ${PUBLISH_ARG} --sbom-output-dir /tmp/output"
echo "${cmd}"
sh -c "${cmd}"
rm -rf /tmp/output/cache
#find /tmp/output -name "*.json"