#/bin/bash

if [ -f /opt/jboss/wildfly/jboss-modules.jar ]; then
    #
    # Do not change
    #
    export WF_HOME=/opt/jboss/wildfly
    export SHARED_LIBS_INPUT=/opt/docker/shared-lib
    
    export DB_URL="jdbc:oracle:thin:@10.98.54.85:1521/XE"
    export REMOTE_EJB_HOST_TEST="10.106.138.99"
    export REMOTE_EJB_PORT_TEST="8083"
    
    echo "Environment is set for DOCKER mode"
else
    #
    # Customize your paths here
    #
    export FCS_HOME=/mnt/c/Users/ike/Projects/fcs
    export WF_HOME=$FCS_HOME/wildfly-test
    export SHARED_LIBS_INPUT=$FCS_HOME/spikes/remotejb/shared-lib
    
    export DB_URL="jdbc:oracle:thin:@localhost:1521/PGZDB"
    export REMOTE_EJB_HOST_TEST="localhost"
    export REMOTE_EJB_PORT_TEST="9082"

    echo "Environment is set for LOCAL mode"
fi
