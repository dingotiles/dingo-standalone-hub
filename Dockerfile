FROM alpine:3.4

ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN apk add --no-cache --update curl bash sed jq go git

ENV ETCD_VERSION=2.3.7
RUN set -x \
      && curl -sL https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -o /tmp/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz \
      && tar xzvf /tmp/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -C /tmp \
      && mv /tmp/etcd-v${ETCD_VERSION}-linux-amd64/etcdctl /usr/local/bin \
      && rm -rf /tmp/etcd*

ENV SPRUCE_VERSION=1.8.1
RUN set -x \
    && curl -L https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERSION}/spruce-linux-amd64 -o /usr/local/bin/spruce \
    && chmod +x /usr/local/bin/spruce

ENV S3CLI_VERSION=0.0.51
RUN set -x \
      && curl -L https://s3.amazonaws.com/s3cli-artifacts/s3cli-${S3CLI_VERSION}-linux-amd64 -o /usr/local/bin/s3cli \
      && chmod +x /usr/local/bin/s3cli

COPY . /go/src/github.com/dingotiles/dingo-postgresql-api
RUN set -x \
    && go install github.com/dingotiles/dingo-postgresql-api
