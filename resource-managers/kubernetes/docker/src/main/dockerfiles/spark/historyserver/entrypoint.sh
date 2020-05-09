#!/usr/bin/env bash

# echo commands to the terminal output
set -ex

if [[ "$enablePVC" == "true" ]]; then
    export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS -Dspark.history.fs.logDirectory=file:/mnt/$eventsDir";
elif [[ "$enableOSS" == "true" ]];then
  export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS \
    -Dspark.history.fs.logDirectory=$eventsDir \
    -Dspark.hadoop.fs.oss.endpoint=$alibabaCloudOSSEndpoint \
    -Dspark.hadoop.fs.oss.accessKeySecret=$alibabaCloudAccessKeySecret \
    -Dspark.hadoop.fs.oss.accessKeyId=$alibabaCloudAccessKeyId \
    -Dspark.hadoop.fs.oss.impl=org.apache.hadoop.fs.aliyun.oss.AliyunOSSFileSystem";
else
    export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS \
    -Dspark.history.fs.logDirectory=$eventsDir";
fi;

if [ -z "${SPARK_HOME}" ]; then
  export SPARK_HOME="$(cd "`dirname "$0"`"/..; pwd)"
fi

. "${SPARK_HOME}/sbin/spark-config.sh"
. "${SPARK_HOME}/bin/load-spark-env.sh"

exec "${SPARK_HOME}/sbin"/spark-daemon.sh start org.apache.spark.deploy.history.HistoryServer 1 "$@"
