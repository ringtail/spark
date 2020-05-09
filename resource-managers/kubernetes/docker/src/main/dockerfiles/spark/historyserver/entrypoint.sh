#!/usr/bin/env bash

# echo commands to the terminal output
set -ex

enablePVC=

enableOSS=
alibabaCloudOSSEndpoint=
alibabaCloudAccessKeyId=
alibabaCloudAccessKeySecret=

eventsDir=

function usage {
  cat<< EOF
  Usage: entrypoint.sh  [OPTIONS]
  Options:
  --pvc                                                 Enable PVC
  --oss accessKeyId accessKeySecret ossEndpoint         Enable Alibaba Cloud OSS
  --events-dir events-dir                               Set events dir
  -h | --help                                           Prints this message.
EOF
}

function parse_args {
  while [[ $# -gt 0 ]]
  do
    case "$1" in
      --pvc)
        enablePVC=true
        shift
        continue
      ;;
      --oss)
      if [[ -n "$4" ]]; then
        enableOSS=true
        alibabaCloudAccessKeyId=$2
        alibabaCloudAccessKeySecret=$3
        alibabaCloudOSSEndpoint=$4
        shift 4
        continue
      else
        printf '"--alibaba" require four non-empty option arguments.\n'
        usage
        exit 1
      fi
      ;;
      --events-dir)
        if [[ -n "$2" ]]; then
          eventsDir=$2
          shift 2
          continue
        else
          printf '"--events-dir" requires a non-empty option argument.\n'
          usage
          exit 1
        fi
      ;;
      -h|--help)
        usage
        exit 0
      ;;
      --)
        shift
        break
      ;;
      '')
        break
      ;;
      *)
        printf "Unrecognized option: $1\n"
        exit 1
      ;;
    esac
    shift
  done
}

parse_args "$@"

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
