#!/usr/bin/env bash
set -ex

export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS \
  -Dspark.history.fs.logDirectory=$EventDir \
  -Dspark.hadoop.fs.oss.endpoint=$Endpoint \
  -Dspark.hadoop.fs.oss.accessKeySecret=$AccessKeySecret \
  -Dspark.hadoop.fs.oss.accessKeyId=$AccessKeyId \
  -Dspark.hadoop.fs.oss.impl=org.apache.hadoop.fs.aliyun.oss.AliyunOSSFileSystem";

exec /sbin/tini -s -- /opt/spark/bin/spark-class org.apache.spark.deploy.history.HistoryServer