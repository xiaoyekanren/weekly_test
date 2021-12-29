if [ "$#" != 1 ]; then
  echo "please input mv data description."
  exit 1
fi

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh
mv ${iotdb_dir}/data_$1 ${iotdb_dir}/data
exit 0
