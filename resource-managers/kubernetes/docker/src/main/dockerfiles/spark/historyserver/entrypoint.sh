#!/usr/bin/env bash

# echo commands to the terminal output
set -ex

if [[ "$enablePVC" == "true" ]]; then
    export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS -Dspark.history.fs.logDirectory=file:/mnt/$eventsDir";
elif [[ "$enableOSS" == "true" ]];then
  export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS \
    -Dspark.history.fs.logDirectory=$eventsDir \
    -Dspark.hadoop.fs.oss.endpoint=$alibabaCloudOSSEndpoint \
    -Dspark.hadoop.fs.oss.accessKeySecret=$alibabaCloudAccessKeyId \
    -Dspark.hadoop.fs.oss.accessKeyId=$alibabaCloudAccessKeySecret \
    -Dspark.hadoop.fs.oss.impl=org.apache.hadoop.fs.aliyun.oss.AliyunOSSFileSystem";
else
    export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS \
    -Dspark.history.fs.logDirectory=$eventsDir";
fi;

exec /usr/bin/tini -s -- /opt/spark/bin/spark-class org.apache.spark.deploy.history.HistoryServer
