FROM dingotiles/dingo-standalone-hub-base

ADD https://cli.run.pivotal.io/stable?release=linux64-binary&version=6.25.0 /tmp/cf.tgz
RUN tar xzf /tmp/cf.tgz -C /usr/bin && rm /tmp/cf.tgz

RUN apt-get update && apt-get install file curl wget bzr jq tree git && apt-get clean
