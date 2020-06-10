#!/bin/bash

#
# НЕ РЕДАКТИРОВАТЬ специально для реестра! Все специфические действия выполнять в setup.sh
# Файл должен быть одинаковым во всех реестрах
#

export WF_CONFIG=$WF_HOME/standalone/configuration

function insert_after {
    tpl="/$1/r ./config/$2"
    sed -i "$tpl" $WF_CONFIG/standalone.xml
    echo "      + Inserted $2 after $1"
}

function insert_before {
    tpl="/$1/e cat ./config/$2"
    sed -i "$tpl" $WF_CONFIG/standalone.xml
    echo "      + Inserted $2 before $1"
}

function insert_after_if_not_exists {
    if ! cat $WF_CONFIG/standalone.xml | grep -q "$3"; then
        insert_after "$1" "$2"
    else
        echo "      - $3 already exists"
    fi
}

function insert_before_if_not_exists {
    if ! cat $WF_CONFIG/standalone.xml | grep -q "$3"; then
        insert_before "$1" "$2"
    else
        echo "      - $3 already exists"
    fi
}

function common_config {
    if [ ! -f $WF_CONFIG/standalone-backup.xml ]; then
        echo "    # First run - backup original standalone.xml"
        cp $WF_CONFIG/standalone.xml $WF_CONFIG/standalone-backup.xml
    else
        echo "    # Restore config from backup"
        cp $WF_CONFIG/standalone-backup.xml $WF_CONFIG/standalone.xml
    fi

    echo "    # Oracle JDBC Driver"
    mkdir -p $WF_HOME/modules/system/layers/base/com/oracle/main
    cp ./com/oracle/main/* $WF_HOME/modules/system/layers/base/com/oracle/main
    insert_after_if_not_exists "<drivers>" driver.xml '<driver name="oracle" module="com.oracle">'

    echo "    # Configuration"
    mkdir -p $WF_HOME/modules/system/layers/base/ru/lanit/config/main
    cp ./ru/lanit/config/main/* $WF_HOME/modules/system/layers/base/ru/lanit/config/main

    echo "    # JSP cache and other dev tweaks"
    sed -i 's/<jsp-config\/>/<jsp-config development="true" check-interval="1" modification-test-interval="1" recompile-on-fail="true"\/>/g' $WF_CONFIG/standalone.xml
    sed -i 's/<servlet-container name="default">/<servlet-container name="default" default-buffer-cache="default" stack-trace-on-error="all">/g' $WF_CONFIG/standalone.xml
    sed -i ':begin;$!N;s/\(<console-handler name="CONSOLE">\)\n/\1/;tbegin;P;D' $WF_CONFIG/standalone.xml
    insert_after_if_not_exists '<\/periodic-rotating-file-handler>' logging.xml '<logger category="org.apache.tiles.template">'

    echo "    # EJB Realm"
    insert_before_if_not_exists '<security-realm name="ApplicationRealm">' secRealm.xml '<security-realm name="ejb-security-realm">'

    echo "    # Modules"
    insert_after_if_not_exists '<subsystem xmlns="urn:jboss:domain:ee:4.0">' modules.xml '<global-modules>'

	monitoring
    logging
}

function socket_binding_group {
    suffix=$1
    envsubst < config/socketBinding_$suffix.xml > config/socketBinding.xml.tmp
    insert_before_if_not_exists '<socket-binding name="management-http"' socketBinding.xml.tmp "remote-ejb-$suffix"
    insert_after_if_not_exists '<subsystem xmlns="urn:jboss:domain:remoting:4.0">' "remoting_$suffix.xml" "remote-ejb-connection-$suffix"
}

function data_source {
    echo "    # Datasource"
    envsubst < config/dataSource.xml > config/dataSource.xml.tmp
    insert_after "<datasources>" dataSource.xml.tmp
}

function naming {
    echo "    # Naming"
    insert_after_if_not_exists '<subsystem xmlns="urn:jboss:domain:naming:2.0">' bindings.xml '<bindings>'
    envsubst < config/naming.xml > config/naming.xml.tmp
    insert_after '<bindings>' naming.xml.tmp
}

function ejb_lookup {
    ds=$1
    envsubst < config/ejbLookup.xml > config/ejbLookup.xml.tmp
    sed -i "/$ds/r ./config/ejbLookup.xml.tmp" $WF_CONFIG/standalone.xml
}

function shared_libs {
    echo "    # Shared libs"
    name=$1
    SHARED_LIBS_OUTPUT=$WF_HOME/modules/ru/lanit/sharedlib/$name/main
    rm -rf $SHARED_LIBS_OUTPUT
    mkdir -p $SHARED_LIBS_OUTPUT
    cp $SHARED_LIBS_INPUT/* $SHARED_LIBS_OUTPUT
}

function mail_session {
    name=$1
    echo "    # Mail Session"
    envsubst < config/mailSession.xml > config/mailSession.xml.tmp
    insert_after_if_not_exists "<subsystem xmlns=\"urn:jboss:domain:mail:3.0\">" mailSession.xml.tmp "java:jboss/mail/$name"

    envsubst < config/socketBinding_mailSession.xml > config/socketBinding.xml.tmp
    insert_before_if_not_exists '<socket-binding name="management-http"' socketBinding.xml.tmp "<outbound-socket-binding name=\"mail-smtp-$name\">"
}

function monitoring {
    echo "    # Monitoring"
	if [ -v MONITORING_URL ]; then
		envsubst < config/dataSource_monitoring.xml > config/dataSource_monitoring.xml.tmp
		insert_after "<datasources>" dataSource_monitoring.xml.tmp
	fi
    insert_after '<managed-executor-services>' executor.xml
}

function logging {
    echo " # Logging"
    mkdir -p $WF_HOME/modules/system/layers/base/ru/lanit/eis/logging/main
    cp ./ru/lanit/eis/logging/main/* $WF_HOME/modules/system/layers/base/ru/lanit/eis/logging/main

    insert_after_if_not_exists '<\/root-logger>' logging_formatter.xml '<formatter name="EIS-FORMATTER">'
    sed -i '/<periodic-rotating-file-handler/,/<\/periodic-rotating-file-handler>/ s/PATTERN/EIS-FORMATTER/g' $WF_CONFIG/standalone.xml
}

function cleanup {
    echo "    # Cleanup"
    rm -f config/*.tmp
    for f in "log" "tmp" "data"
    do
        rm -rf $WF_HOME/standalone/$f
        mkdir $WF_HOME/standalone/$f
    done
    echo "DONE!"
}