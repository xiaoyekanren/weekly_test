#!/bin/bash
remote_str=$1
server_shell_dir=$2
user=$3
benchmark_shell_dir=$4
bk_desc=$5
comp_val=$6
start_iodtdb=$7
end_str=$8
#flush
${remote_str}"${server_shell_dir}/flush.sh"${end_str}
#停止iotdb服务
${remote_str}"${server_shell_dir}/stop_iotdb.sh"${end_str}

#iotdb mv data logs 保存 不在此数据上执行乱序查询
${remote_str}"${server_shell_dir}/mv_data.sh ${bk_desc}"${end_str}

#iotdb 数据库所在机器 清操作系统缓存
${remote_str}"${server_shell_dir}/clear_cache.sh"${end_str}
#设置合并参数
${remote_str}"${server_shell_dir}/set_compaction_strategy.sh ${comp_val}"${end_str}
#benchmark机器清缓存
${benchmark_shell_dir}/clear_cache.sh

#iotdb 数据库启动
if [ "$start_iodtdb" = "true" ];then
   ${remote_str}"${server_shell_dir}/start_iotdb.sh"${end_str}
   #检查iotdb进程启动是否成功
   ${remote_str}"${server_shell_dir}/show_version.sh"${end_str}
   sleep 1s
fi

