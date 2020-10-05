FROM remote-ejb-transactions

COPY client.ear /opt/jboss/wildfly/standalone/deployments

ENV JAVA_OPTS="-Xms64m -Xmx512m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -Djboss.socket.binding.port-offset=1 -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS -Djava.awt.headless=true"
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"] #, "--debug", "*:8787"

EXPOSE 8081
EXPOSE 9991
EXPOSE 8787
