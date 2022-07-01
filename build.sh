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
SBOM_DIR=${PLUGIN_SBOM_DIR:=/tmp/sbom}

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
if [[ $PUBLISH = "true" ]]; then
    echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin ${REGISTRY}
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


cmd="pack build ${REPO}:${PRIMARY_TAG} --path ${CWD} --builder ${BUILDER} ${BUILDPACK_ARG} ${TAG_ARG} ${PUBLISH_ARG} --sbom-output-dir ${SBOM_DIR} --pull-policy if-not-present"

sh -c "${cmd}"
rm -rf $SBOM_DIR/cache
#find /tmp/output -name "*.json"

if [[ $PUBLISH ]]; then
    if [[ $PLUGIN_ARTIFACT_FILE ]]; then
        mkdir -p $(dirname $PLUGIN_ARTIFACT_FILE)
        cat >$PLUGIN_ARTIFACT_FILE << EOF
{
    "kind": "fileUpload/v1",
    "data": {
        "fileArtifacts": [
            {
                "name": "Docker",
                "url": "https://${REPO}:${PRIMARY_TAG}"
            }
        ]
    }
} 
EOF
    fi
fi