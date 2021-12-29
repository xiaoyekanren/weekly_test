DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh

sed -i "s/.*compaction_strategy=.*/compaction_strategy=$1/g" ${iotdb_dir}/conf/iotdb-engine.properties

#备份配置文件

cp ${iotdb_dir}/conf/iotdb-engine.properties "${iotdb_dir}/conf/iotdb-engine.properties.compaction_strategy_$1"

