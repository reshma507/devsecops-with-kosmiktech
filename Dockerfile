From tomcat:9
MAINTAINER "Kosmik"
COPY webapp/target/webapp.war /usr/local/tomcat/webapps
EXPOSE 8080
