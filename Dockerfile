# docker run -dt -p 8111:8111 ariya/centos7-teamcity-server

FROM ariya/centos7-oracle-jre7

MAINTAINER Hargitai Dávid <diatigrah@gmail.com>

# TeamCity data is stored in a volume to facilitate container upgrade
VOLUME  ["/data/teamcity"]
ENV TEAMCITY_DATA_PATH /data/teamcity

# Download and install TeamCity to /opt
RUN yum -y install tar wget
ENV TEAMCITY_PACKAGE TeamCity-9.0.4.tar.gz
ENV TEAMCITY_DOWNLOAD http://download.jetbrains.com/teamcity
RUN wget $TEAMCITY_DOWNLOAD/$TEAMCITY_PACKAGE && \
    tar zxf $TEAMCITY_PACKAGE -C /opt && \
    rm -rf $TEAMCITY_PACKAGE

EXPOSE 8111
CMD ["/opt/TeamCity/bin/teamcity-server.sh", "run"]
