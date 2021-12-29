DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh

nohup ${iotdb_dir}/sbin/start-server.sh >/dev/null 2>&1 &
if [ "$?" != 0 ]; then
  echo "start iotdb server failed."
else
  echo "start iotdb server successed."
fi

