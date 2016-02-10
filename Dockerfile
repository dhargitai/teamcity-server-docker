FROM frolvlad/alpine-oraclejdk8:slim

ENV TEAMCITY_VERSION 9.1.6

ENV TEAMCITY_DATA_PATH /teamcity-home

ENV TEAMCITY_SERVER_MEM_OPTS \
 -Xms768m \
 -Xmx1280m \
 -Xss256k

ENV TEAMCITY_SERVER_OPTS \
 -server \
 -XX:+UseCompressedOops \
 -Djsse.enableSNIExtension=false \
 -Djava.awt.headless=true \
 -Dfile.encoding=UTF-8 \
 -Duser.timezone=Europe/Amsterdam

EXPOSE 8111

VOLUME ["/teamcity", "/backup"]

RUN apk add --update wget gnupg unzip bash subversion git

RUN mkdir -p /teamcity-home/lib/jdbc /backup /teamcity-home/backup \
	&& addgroup -g 999 teamcity \
	&& adduser -u 999 -G teamcity -D -H -h /teamcity-home teamcity \
	&& wget -O /teamcity.tar.gz --progress=bar:force http://download.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.tar.gz \
	&& wget -q -O /teamcity-home/lib/jdbc/postgresql-9.4-1205.jdbc42.jar https://jdbc.postgresql.org/download/postgresql-9.4-1205.jdbc42.jar \
	&& ln -s /backup /teamcity-home/backup \
	&& tar xzf teamcity.tar.gz \
	&& rm -rf /teamcity.tar.gz \
	&& chown -R teamcity:teamcity /teamcity-home /backup /TeamCity

RUN sed -i 's/connectionTimeout="20000"/connectionTimeout="60000" useBodyEncodingForURI="true" socket.txBufSize="64000" socket.rxBufSize="64000"/' /TeamCity/conf/server.xml

USER teamcity

CMD ["/TeamCity/bin/teamcity-server.sh", "run"]