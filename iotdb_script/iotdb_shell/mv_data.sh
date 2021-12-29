if [ "$#" != 1 ]; then
  echo "please input mv data description."
  exit 1
fi

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh
mv ${iotdb_dir}/data ${iotdb_dir}/data_$1
mv ${iotdb_dir}/logs ${iotdb_dir}/logs_$1
cp ${iotdb_dir}/conf/iotdb-env.sh ${iotdb_dir}/data_$1
cp ${iotdb_dir}/conf/iotdb-engine.properties ${iotdb_dir}/data_$1

exit 0
