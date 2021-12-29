DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh

stop-server.sh
if [ "$?" != 0 ]; then
  echo "stop iotdb server failed."
else
  echo "stop iotdb server successed."
fi
