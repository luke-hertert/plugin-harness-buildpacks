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

COPY build.sh /build.sh
RUN chmod +x /build.sh

CMD [ "/build.sh" ]
