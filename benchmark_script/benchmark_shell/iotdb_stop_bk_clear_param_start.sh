#!/bin/bash
remote_str=$1
server_shell_dir=$2
benchmark_shell_dir=$3
bk_desc=$4
comp_val=$5
start_iodtdb=$6
#flush
eval ${remote_str}"${server_shell_dir}/flush.sh"
#停止iotdb服务
eval ${remote_str}"${server_shell_dir}/stop_iotdb.sh"

#iotdb mv data logs 保存 不在此数据上执行乱序查询
eval ${remote_str}"${server_shell_dir}/mv_data.sh ${bk_desc}"

#iotdb 数据库所在机器 清操作系统缓存
eval ${remote_str}"${server_shell_dir}/clear_cache.sh"
#设置合并参数
eval ${remote_str}"${server_shell_dir}/set_compaction_strategy.sh ${comp_val}"
#benchmark机器清缓存
${benchmark_shell_dir}/clear_cache.sh

#iotdb 数据库启动
if [ "$start_iodtdb" = "true" ];then
   eval ${remote_str}"${server_shell_dir}/start_iotdb.sh"
   #检查iotdb进程启动是否成功
   eval ${remote_str}"${server_shell_dir}/show_version.sh"
   sleep 1s
fi

