#!/bin/bash
remote_str=$1
server_shell_dir=$2
user=$3
benchmark_shell_dir=$4
end_str=$5
#停止iotdb服务
${benchmark_shell_dir}/clear_cache.sh
${remote_str}"${server_shell_dir}/stop_iotdb.sh"${end_str}

#iotdb 数据库所在机器 清操作系统缓存
${remote_str}"${server_shell_dir}/clear_cache.sh"${end_str}

#iotdb 数据库启动
${remote_str}"${server_shell_dir}/start_iotdb.sh"${end_str}
#检查iotdb进程启动是否成功
${remote_str}"${server_shell_dir}/show_version.sh"${end_str}
sleep 1s
