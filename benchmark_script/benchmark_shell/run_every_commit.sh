#!/bin/bash
benchmark_shell_dir="$( cd "$( dirname "$0"  )" && pwd  )"
server_test_dir="/data/benchmark/weekly_shell"
server_shell_dir="${server_test_dir}/iotdb_shell"
sleep_time=1800
remote_test="true"
server_ip="192.168.130.14"
user="cluster"
#start_time=`date +%Y-%m-%d-%H-%M-%S`
start_time="master_weekly_test"
remote_str=""
#iotdb 数据库所在机器
result_path="${benchmark_shell_dir}/result"
if [ ! -d  $result_path ]
then
   mkdir "${result_path}" 
fi
if [ ${remote_test} = "true" ];then
   remote_str="ssh ${user}@${server_ip} "
fi
while true
do
  eval ${remote_str}"${server_shell_dir}/scan_commit.sh ${sleep_time}"
   
  # if [ "$?" != 0 ]; then
  #   echo "iotdb server git pull or mvn failed."
  #   exit 1
  # fi
  
  ${benchmark_shell_dir}/run_weektest.sh "${remote_str}" ${server_test_dir} ${start_time}
done
