FROM debian:buster
RUN apt-get -y update --fix-missing
MAINTAINER Avocado

#Payment App installation:
COPY jre1.8.0_102/ /usr/lib/jvm/java-8-openjdk-amd64/jre/
RUN chmod -R 755 /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

#COPY target/paymentOptionsVault-0.0.1-SNAPSHOT.war /
COPY paymentOptionsVault-0.0.1-SNAPSHOT.war /

#-------------------------------------------------------------------------------------
#Plugin Installtion START
#-------------------------------------------------------------------------------------
ARG ADPL_PLUGIN_PACKAGE
RUN apt-get install -y net-tools procps
# ASP installation and configuration
COPY avcdadpl_3.0.101.debian10_amd64.deb  /

#Manual Install ASP
RUN apt-get install -y /avcdadpl_3.0.101.debian10_amd64.deb
RUN /opt/avcd/bin/avocado container-enable

ENTRYPOINT [ "/opt/avcd/bin/avocado-docker-start.sh" ]
#-------------------------------------------------------------------------------------
#Plugin Installtion END
#-------------------------------------------------------------------------------------
# Replace <APPLICATION_START_COMMAND> with your Application start command in below entrypoint
CMD ["/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java", "-jar", "/paymentOptionsVault-0.0.1-SNAPSHOT.war"]
