
# Building

```sh
docker build --rm -f "Dockerfile" -t ldhertert/harness-buildpacks:latest "."
```

# Running locally

```sh
git clone https://github.com/orian/go-echoserver /tmp/go-echoserver

REPO="ldhertert/go-echoserver"
TAG="latest v2"
BUILDER="gcr.io/paketo-buildpacks/builder:base"
BUILDPACK="paketo-buildpacks/go@1.5.0"
CWD="./"

docker run --rm \
    -v /tmp/go-echoserver:/drone/src \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -w /drone/src \
    -e PLUGIN_REPO="${REPO}" \
    -e PLUGIN_TAG="${TAG}" \
    -e PLUGIN_BUILDER="${BUILDER}" \
    -e PLUGIN_BUILDPACK="${BUILDPACK}" \
    --name harness-buildpacks \
    ldhertert/harness-buildpacks:latest 
```

# Publishing

```
docker push ldhertert/harness-buildpacks:latest
```