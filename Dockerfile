FROM java:8-jre-alpine

COPY ./modules/ /tmp/eap/modules/
COPY ./distribution/ /tmp/eap/
COPY ./standalone-conf/ /tmp/eap/standalone-conf/


EXPOSE 9999 8009 8080 8443 8090 9990

ENV HOME /home/jboss
ENV JBOSS_HOME /opt/jboss-eap-6.4

RUN addgroup -g 1000 jboss && \
      adduser -u 1000 -D -s /sbin/nologin -g "JBoss" -G jboss jboss && \
      mkdir -p $JBOSS_HOME && \
      unzip /tmp/eap/*.zip -d /opt && \
      for f in $(ls /tmp/eap/modules); do echo "Copy module $f" && cp -R /tmp/eap/modules/$f $JBOSS_HOME/modules/$f; done && \
      for f in $(ls /tmp/eap/standalone-conf); do echo "Copy standalone-conf $f" && cp -R /tmp/eap/standalone-conf/$f $JBOSS_HOME/standalone/configuration/$f; done

COPY ./entrypoint.sh $JBOSS_HOME/entrypoint.sh

RUN chmod +x $JBOSS_HOME/entrypoint.sh && \
      chown -R jboss:jboss $JBOSS_HOME && \
      rm -rf /tmp/eap

USER 1000

ENTRYPOINT $JBOSS_HOME/entrypoint.sh