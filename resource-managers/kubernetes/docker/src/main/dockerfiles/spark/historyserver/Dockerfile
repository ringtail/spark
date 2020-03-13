FROM registry.aliyuncs.com/acs/spark:ack-2.4.5-latest
# Add dependency for alibaba cloud
ADD http://repo.alibaba-inc.com/nexus/content/groups/b2brepository/org/apache/hadoop/hadoop-aliyun/2.7.2-rc5/hadoop-aliyun-2.7.2-rc5.jar $SPARK_HOME/jars
ADD http://repo.alibaba-inc.com/nexus/content/groups/b2brepository/com/aliyun/oss/aliyun-sdk-oss/3.4.1/aliyun-sdk-oss-3.4.1.jar $SPARK_HOME/jars

# change default entrypoint
ADD resource-managers/kubernetes/docker/src/main/dockerfiles/historyserver/entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]