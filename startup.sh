#!/bin/bash
CWD=${PWD}
cd /ECommerce-Java;gradle createDB

if [ -n "${web}" ]; then
        cp  /ECommerce-Java/ECommerce-Web/build/libs/appdynamicspilot.war /tomcat/webapps
        JAVA_OPTS="-DlistPort=8000 -DshutdownPort=8100 -DajpPort=8009"
fi

if [ -n "${jms}" ]; then
  cp /ECommerce-Java/ECommerce-JMS/build/libs/appdynamicspilotjms.war /tomcat/webapps
        JAVA_OPTS="-DlistPort=8003 -DshutdownPort=8100 -DajpPort=8010"
fi

if [ -n "${ws}" ]; then
        cp /ECommerce-Java/ECommerce-WS/build/libs/cart.war /tomcat/webapps
         JAVA_OPTS="-DlistPort=8002 -DshutdownPort=8100 -DajpPort=8010"
fi



JAVA_OPTS="${JAVA_OPTS} -Xmx512m -XX:MaxPermSize=128m -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dappdynamics.agent.uniqueHostId=cart-machine"


cd ${CATALINA_HOME}/bin;
echo "java ${JAVA_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap"

apachectl start
java ${JAVA_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap


cd ${CWD}