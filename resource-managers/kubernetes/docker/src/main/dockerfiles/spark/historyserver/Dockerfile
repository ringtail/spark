FROM registry.aliyuncs.com/acs/spark:ack-2.4.5-latest
# Add dependency for alibaba cloud
ADD http://gosspublic.alicdn.com/hadoop-spark/hadoop-oss-2.7.2.tar.gz $SPARK_HOME/jars
ADD https://repo1.maven.org/maven2/com/aliyun/oss/aliyun-sdk-oss/3.8.1/aliyun-sdk-oss-3.8.1.jar $SPARK_HOME/jars

# change default entrypoint
ADD resource-managers/kubernetes/docker/src/main/dockerfiles/historyserver/entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]
