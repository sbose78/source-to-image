FROM openshift/origin-release:golang-1.13 AS builder

ENV S2I_GIT_VERSION="" \
    S2I_GIT_MAJOR="" \
    S2I_GIT_MINOR=""

ENV GOARCH="amd64"

WORKDIR source-to-image
COPY . source-to-image

RUN  make && \
    install _output/local/bin/linux/${GOARCH}/s2i /usr/local/bin

#
# Runner Image
#

FROM registry.access.redhat.com/ubi7/ubi-minimal

COPY --from=builder /usr/local/bin/s2i /usr/local/bin

USER 10001

ENTRYPOINT [ "/usr/local/bin/s2i" ]