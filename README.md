
# Usage

### Options
```sh
#The destination docker repostory 
export PLUGIN_REPO=ldhertert/go-echoserver

#Tag(s) for the build image
export PLUGIN_TAG=latest

# The builder to use. See https://paketo.io/docs/concepts/builders/ for details and available builders.
export PLUGIN_BUILDER=paketobuildpacks/builder:tiny

# The buildpack to use (optional).
export PLUGIN_BUILDPACK="gcr.io/paketo-buildpacks/go"

# Path to app dir or zip-formatted file (defaults to current working directory)
export PLUGIN_CWD=./

#####The following options are only necessary if you want to publish to a target registry in addition to building

# Publish to registry
export PLUGIN_PUBLISH=true

# Registry to push to. (optional, defaults to docker.io)
export PLUGIN_REGISTRY=docker.io

# Docker registry credentials
export PLUGIN_USERNAME='your docker username'
export PLUGIN_PASSWORD='your docker password'

# Cache build layers in remote registry. Requires --publish
export PLUGIN_CACHE_IMAGE=ldhertert/go-echoserver-buildcache
```

### Running in docker
```sh
# Clone sample app to local machine
git clone https://github.com/orian/go-echoserver /tmp/workspace
export PLUGIN_WORKSPACE="/worspace"

docker run --rm \
    -v "/tmp/workspace:${PLUGIN_WORKSPACE}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e PLUGIN_REPO="${PLUGIN_REPO}" \
    -e PLUGIN_TAG="${PLUGIN_TAG}" \
    -e PLUGIN_BUILDER="${PLUGIN_BUILDER}" \
    -e PLUGIN_BUILDPACK="${PLUGIN_BUILDPACK}" \
    -e PLUGIN_CWD="${PLUGIN_CWD}" \
    -e PLUGIN_PUBLISH="${PLUGIN_PUBLISH}" \
    -e PLUGIN_REGISTRY="${PLUGIN_REGISTRY}" \
    -e PLUGIN_USERNAME="${PLUGIN_USERNAME}" \
    -e PLUGIN_PASSWORD="${PLUGIN_PASSWORD}" \
    -e PLUGIN_CACHE_IMAGE="${PLUGIN_CACHE_IMAGE}" \
    --name harness-buildpacks \
    ldhertert/harness-buildpacks:latest 
```

### Running without docker
```sh
./build.sh
```

# Development

### Building

```sh
docker build --rm -f "Dockerfile" -t ldhertert/harness-buildpacks:latest "."
```
