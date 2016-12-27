FROM registry.centos.org/centos/centos 

RUN yum update -y && yum install -y tar nc && yum clean all
RUN mkdir -p /mattermost/data

RUN curl -LO https://releases.mattermost.com/3.5.1/mattermost-team-3.5.1-linux-amd64.tar.gz && tar -xf mattermost-team-3.5.1-linux-amd64.tar.gz && rm -f mattermost-team-3.5.1-linux-amd64.tar.gz

RUN rm /mattermost/config/config.json
COPY config.template.json /mattermost/config/config.json
RUN chmod -R 777 /mattermost/config

RUN touch /mattermost/logs/mattermost.log
RUN chmod a+rw /mattermost/logs/mattermost.log

RUN chmod a+w /mattermost/data

COPY docker-entry.sh /
RUN chmod +x /docker-entry.sh
ENTRYPOINT ["/docker-entry.sh"]

EXPOSE 8080
# for https connections
EXPOSE 443
