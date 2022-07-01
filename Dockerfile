FROM docker:dind

ARG VERSION=v0.27.0

# Install package deps
RUN apk add --update --no-cache wget curl bash
    
# Download buildpack cli
RUN wget -qO- https://github.com/buildpacks/pack/releases/download/${VERSION}/pack-${VERSION}-linux.tgz | tar xvz -C /usr/bin

ENV PLUGIN_REPO="unknown"
ENV PLUGIN_TAG="latest"
ENV PLUGIN_BUILDER="gcr.io/paketo-buildpacks/builder:base"
ENV PLUGIN_BUILDPACK=""
ENV PLUGIN_CWD="./"
ENV PLUGIN_PUBLISH="false"
ENV PLUGIN_REGISTRY="docker.io"
ENV PLUGIN_USERNAME=""
ENV PLUGIN_PASSWORD=""
ENV PLUGIN_CACHE_IMAGE=""

COPY build.sh /build.sh

CMD [ "/build.sh" ]