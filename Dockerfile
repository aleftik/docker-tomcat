# install Java7 from http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
FROM centos:latest
RUN yum -y install wget
RUN yum -y install git
RUN yum -y install unzip
RUN yum -y install tar
#hack for centos docker bug
RUN mkdir -p /run/lock
RUN yum -y install httpd

#FOR HTTPD
ADD ajp_proxy.conf /etc/httpd/conf.d/

#JDK
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.rpm -O jdk-linux-x64.rpm
RUN rpm -Uvh jdk-linux-x64.rpm

RUN rm jdk-linux-x64.rpm
ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin

#GRADLE
RUN wget -N http://services.gradle.org/distributions/gradle-2.1-all.zip
RUN unzip gradle-2.1-all.zip -d /opt/
RUN rm gradle-2.1-all.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# GIT Checkout
RUN git clone https://github.com/Appdynamics/ECommerce-Java.git

#Gradle
RUN cd /ECommerce-Java;gradle war

#TOMCAT
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.14
ENV CATALINA_HOME /tomcat

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

RUN cd ${CATALINA_HOME}/bin;chmod +x *.sh
ADD startup.sh /
RUN chmod +x /startup.sh
WORKDIR /
CMD ["/bin/bash","/startup.sh"]

EXPOSE 80
EXPOSE 8009
EXPOSE 8000	