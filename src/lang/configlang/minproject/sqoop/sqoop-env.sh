# Set Hadoop-specific environment variables here.

#Set path to where bin/hadoop is available
export HADOOP_COMMON_HOME=/opt/hadoop-2.7.4

#Set path to where hadoop-*-core.jar is available
export HADOOP_MAPRED_HOME=/opt/hadoop-2.7.4

#Set the path to where bin/hive is available
export HIVE_HOME=/opt/hive

export HIVE_CONF_DIR=/opt/hive/conf

cp $HIVE_HOME/lib/hive-common-2.3.2.jar $SQOOP_HOME/lib
