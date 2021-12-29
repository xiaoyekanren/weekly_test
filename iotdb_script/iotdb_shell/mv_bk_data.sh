if [ "$#" != 1 ]; then
  echo "please input mv data description."
  exit 1
fi

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh
rm -rf ${iotdb_dir}/data
mv ${DIR}/data_$1 ${iotdb_dir}/data
exit 0
