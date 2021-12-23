FROM jboss/jbpm-server-full:latest

WORKDIR /opt/jboss/wildfly

USER root

RUN curl -L https://downloads.jboss.org/keycloak/11.0.2/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-11.0.2.tar.gz | tar zx && \
    curl -L https://downloads.jboss.org/keycloak/11.0.2/adapters/saml/keycloak-saml-wildfly-adapter-dist-11.0.2.tar.gz | tar zx 
    
WORKDIR $JBOSS_HOME/bin/

COPY business-central.war /opt/jboss/wildfly/standalone/deployments/business-central.war
COPY kie-server.war /opt/jboss/wildfly/standalone/deployments/kie-server.war
COPY standalone.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml
COPY mgmt-users.properties /opt/jboss/wildfly/standalone/configuration/mgmt-users.properties
COPY jbpm-postgres-config.cli  /opt/jboss/wildfly/bin/jbpm-postgres-config.cli
COPY kie-git.json /opt/jboss/wildfly/kie-git.json

####### CUSTOM JBOSS USER ############
# Switchback to jboss user
USER jboss

####### EXPOSE INTERNAL JBPM GIT PORT ############
EXPOSE 8001
EXPOSE 8080

####### RUNNING JBPM-WB ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_jbpm-wb.sh"]