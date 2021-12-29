DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh
sleep 10s
for i in {1..180}
do
iotdb_version=`${iotdb_dir}/sbin/start-cli.sh -e "show version"`
echo $iotdb_version
is_running=`echo $iotdb_version|grep "line number = 1"|wc -l`
if [ "$is_running" != 1 ]; then
  echo "iotdb is not running."
  sleep 1s
else
  echo "iotdb is running."
  exit 0
fi
done
exit 1
