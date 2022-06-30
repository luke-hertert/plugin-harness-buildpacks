#!/bin/bash

set -e

REPO=$PLUGIN_REPO
TAG=$PLUGIN_TAG
BUILDER=$PLUGIN_BUILDER
BUILDPACK=$PLUGIN_BUILDPACK
CWD=$PLUGIN_CWD

# Test docker socket
curl --fail --silent -o /dev/null --unix-socket /run/docker.sock http://localhost/version || \
    { echo "Error connecting to docker socket.  Ensure container /var/run/docker.sock is properly mounted."; exit 1; }

# Get first tag from array for main image
TAG_ARG=""
TAG_ARRAY=(${TAG})
BUILT_IMAGE=${REPO}:${TAG_ARRAY[0]}
unset 'TAG_ARRAY[0]'

# Add additional tags arguments if provided
for t in "${TAG_ARRAY[@]}"
do
    TAG_ARG+=" --tag ${REPO}:${t} "
done

# Create buildpack arguments if provided
[[ -z "${BUILDPACK}" ]] && BUILDPACK_ARG="" || BUILDPACK_ARG="--buildpack ${BUILDPACK}"

echo "Building ${BUILT_IMAGE} from ${CWD}"

cmd="pack build ${BUILT_IMAGE} --path ${CWD} --builder ${BUILDER} ${BUILDPACK_ARG} ${TAG_ARG} --sbom-output-dir /output"
sh -c "${cmd}"
# pack sbom download ${BUILT_IMAGE} --output-dir /output
rm -rf /output/cache
find /output -name "*.json"