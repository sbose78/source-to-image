FROM openshift/origin-release:golang-1.13 AS builder

ENV S2I_GIT_VERSION="" \
    S2I_GIT_MAJOR="" \
    S2I_GIT_MINOR=""


WORKDIR /tmp/source-to-image
COPY . .

ENV GOARCH="amd64"
RUN make

#
# Runner Image
#

FROM registry.access.redhat.com/ubi7/ubi-minimal

ENV GOARCH="amd64"

COPY --from=builder /tmp/source-to-image/_output/local/bin/linux/${GOARCH}/s2i  /usr/local/bin/s2i

USER 10001

ENTRYPOINT [ "/usr/local/bin/s2i" ]