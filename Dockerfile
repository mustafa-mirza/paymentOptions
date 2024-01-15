FROM debian:buster
RUN apt-get -y update --fix-missing
MAINTAINER Avocado

# Add a new user "john" with user id 8877
#RUN useradd avuser

#Payment App installation:
COPY jre1.8.0_102/ /usr/lib/jvm/java-8-openjdk-amd64/jre/
RUN chmod -R 755 /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

COPY target/paymentOptionsVault-0.0.1-SNAPSHOT.war /

#RUN chown avuser:avuser -R /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/

# Replace <APPLICATION_START_COMMAND> with your Application start command in below entrypoint
#CMD [ "/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -jar /app/paymentOptionsVault-0.0.1-SNAPSHOT.war" ]
CMD [ "/bin/bash", "-c", "/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -jar /paymentOptionsVault-0.0.1-SNAPSHOT.war" ]
