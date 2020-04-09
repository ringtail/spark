FROM maven:3.5.4-jdk-8 AS build-env
ADD . /spark
WORKDIR /spark/examples
ENV MAVEN_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=1g"
RUN mvn clean package


ARG base_img=registry.aliyuncs.com/acs/spark:ack-2.4.5-latest
FROM $base_img
COPY --from=build-env /spark/examples/target/*.jar  /opt/spark/examples/
