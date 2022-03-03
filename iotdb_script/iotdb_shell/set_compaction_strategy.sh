DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh
iotdb_version=`grep "enable_seq_space_compaction=" conf/iotdb-engine.properties |wc -l`

if [ "${iotdb_version}" = "1" ]; then
  if [ "$1" = "LEVEL_COMPACTION" ];then
     v_enable="true"
  else
     v_enable="false"
  fi
  sed -i "s/.*enable_seq_space_compaction=.*/enable_seq_space_compaction=${v_enable}/g" ${iotdb_dir}/conf/iotdb-engine.properties
  sed -i "s/.*enable_unseq_space_compaction=.*/enable_unseq_space_compaction=${v_enable}/g" ${iotdb_dir}/conf/iotdb-engine.properties
  sed -i "s/.*enable_cross_space_compaction=.*/enable_cross_space_compaction=${v_enable}/g" ${iotdb_dir}/conf/iotdb-engine.properties
else
  sed -i "s/.*compaction_strategy=.*/compaction_strategy=$1/g" ${iotdb_dir}/conf/iotdb-engine.properties
fi

#备份配置文件

cp ${iotdb_dir}/conf/iotdb-engine.properties "${iotdb_dir}/conf/iotdb-engine.properties.compaction_strategy_$1"

