#!/bin/bash

export FCS_HOME=/mnt/c/Users/ike/Projects/fcs
export SHARED_LIBS_INPUT=$FCS_HOME/spikes/quartz/shared-lib
export SCHEDULER_DB_URL="jdbc:oracle:thin:@localhost:1521/FCSDB"

. ./setenv.sh.template
. ./setenv.sh

function run {
    . ./common.sh
    common_config
    data_source
    naming
    socket_binding_group test
    #clear_deployments
    cleanup
}

function clear_deployments {
    echo "    # Clearing deployments"
    for ext in "ear" "deployed" "dodeploy" "failed"
    do
        rm -rf $WF_HOME/standalone/deployments/*.$ext
    done
}

if [ -f /opt/jboss/wildfly/jboss-modules.jar ]; then
    run
else
    export WF_HOME=$FCS_HOME/wildfly-client
    run
    export WF_HOME=$FCS_HOME/wildfly-client-slave
    run
    export WF_HOME=$FCS_HOME/wildfly-server
    run
    export WF_HOME=$FCS_HOME/wildfly-server-slave
    run
fi
