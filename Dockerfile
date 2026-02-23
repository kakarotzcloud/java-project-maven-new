FROM tomcat:9.0-jdk17-temurin AS builder

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/myapp.war /usr/local/tomcat/webapps/myapp.war

FROM gcr.io/distroless/java17-debian12

ENV CATALINA_HOME=/usr/local/tomcat
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

COPY --from=builder /usr/local/tomcat /usr/local/tomcat

EXPOSE 8080

ENTRYPOINT ["java"]

CMD [   "-Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties",   "-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager",   "-Dcatalina.home=/usr/local/tomcat",   "-Dcatalina.base=/usr/local/tomcat",   "-classpath",   "/usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar",   "org.apache.catalina.startup.Bootstrap",   "start" ]
