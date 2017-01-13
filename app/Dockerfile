FROM registry.centos.org/centos/centos

MAINTAINER sgk <sgk@redhat.com>

# Labels consumed by Red Hat build service
LABEL Component="mattermost" \
      Name="centos/mattermost-3.6.0-centos7" \
      Version="3.6.0" \
      Release="1"

# Labels could be consumed by OpenShift
LABEL io.k8s.description="Mattermost is an open source, self-hosted Slack-alternative" \
      io.k8s.display-name="Mattermost 3.6.0" \
      io.openshift.expose-services="8080:mattermost" \
      io.openshift.tags="mattermost,slack"


RUN yum update -y && yum install -y tar nc && yum clean all

RUN curl -LO https://releases.mattermost.com/3.6.0/mattermost-team-3.6.0-linux-amd64.tar.gz && tar -xf mattermost-team-3.6.0-linux-amd64.tar.gz && rm -f mattermost-team-3.6.0-linux-amd64.tar.gz

VOLUME ["/mattermost/config"]
VOLUME ["/mattermost/logs"]

COPY docker-entry.sh /

RUN chmod +x /docker-entry.sh
ENTRYPOINT ["/docker-entry.sh"]

EXPOSE 8080
# for https connections
EXPOSE 443
