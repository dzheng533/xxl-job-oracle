FROM openjdk:8u212-jre-slim
MAINTAINER Vincent Dong

ENV PARAMS=""

ENV TZ=PRC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /apps/job-admin/config && mkdir -p /apps/job-admin/logs
COPY target/application.yml /apps/job-admin/config/application.yml
COPY target/xxl-job-admin-*.jar /apps/job-admin/app.jar

ENTRYPOINT ["sh","-c","java -jar /apps/job-admin/app.jar "]