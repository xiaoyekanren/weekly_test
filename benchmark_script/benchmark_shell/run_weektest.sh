#!/bin/bash
benchmark_shell_dir="$( cd "$( dirname "$0"  )" && pwd  )"
benchmark_result_dir=${benchmark_shell_dir}/../benchmark_result
#各版本测试结果保存在$test_time_$commit_id_result中
test_time=`date +%Y-%m-%d-%H-%M-%S`
remote_str=$1
server_test_dir=$2
user=$3
server_shell_dir="${server_test_dir}/iotdb_shell"
every_iotdb_dir="${server_test_dir}/iotdb_test"
time1=`date +%s`
start_iotdb="true"
#各版本测试结果$start_time_res.csv
start_time=$4
#获取本次测试的iotdb的commit_id,创建结果目录
v_cmd="tail -1 ${server_shell_dir}/commit_id.txt"
commit_id=`eval ${remote_str}"${v_cmd}"`
test_result_path="${test_time}_${commit_id}_result"
mkdir -p ${benchmark_result_dir}/${test_result_path}
if [ "$?" != 0 ]; then
  echo "mkdir result path failed."
  exit 1
fi

#顺序写入
#iotdb 修改合并参数 清操作系统缓存 启动数据库

eval ${remote_str}"${server_shell_dir}/set_compaction_strategy.sh LEVEL_COMPACTION"
${benchmark_shell_dir}/iotdb_stop_clear_start.sh "${remote_str}" "$server_shell_dir" "${user}" ${benchmark_shell_dir}
#Benchmark copy 顺序写入的配置文件
${benchmark_shell_dir}/cp_bm_conf.sh "insert_no_overflow.config.properties"

#启动shun序写入测试
${benchmark_shell_dir}/run_bm.sh "${benchmark_result_dir}/${test_result_path}" insert_no_overflow

#记录执行结果 fail写到fail文件 性能值写到结果文件

${benchmark_shell_dir}/write_fail_and_result.sh "${benchmark_result_dir}/${test_result_path}" "insert_no_overflow.out" "INGESTION" "result_nooverflow_fail_1" "result_nooverflow_1"

#backup config
#${benchmark_shell_dir}/bk_bm_conf.sh "${benchmark_result_dir}/${test_result_path}" "insert_no_overflow.config.properties"
#顺序写入测试完成 flush stop-iotdb 备份 清缓存  start-iotdb
${benchmark_shell_dir}/iotdb_stop_bk_clear_param_start.sh "${remote_str}" "${server_shell_dir}" "${user}" "${benchmark_shell_dir}" "nooverflow_merge" "LEVEL_COMPACTION" "${start_iotdb}"

#copy 乱序写入的conf
${benchmark_shell_dir}/cp_bm_conf.sh "insert_is_overflow.config.properties"
#启动乱序写入测试
${benchmark_shell_dir}/run_bm.sh "${benchmark_result_dir}/${test_result_path}" insert_is_overflow_merge

#记录执行结果 fail写到fail文件 性能值写到结果文件

${benchmark_shell_dir}/write_fail_and_result.sh "${benchmark_result_dir}/${test_result_path}" "insert_is_overflow_merge.out" "INGESTION" "result_isoverflow_fail_1" "result_isoverflow_1"
let line_num++

#backup config
#${benchmark_shell_dir}/bk_bm_conf.sh "${benchmark_result_dir}/${test_result_path}" "insert_is_overflow.config.properties"

#乱序写入测试完成 flush stop-iotdb 备份 清缓存  start-iotdb
${benchmark_shell_dir}/iotdb_stop_bk_clear_param_start.sh "${remote_str}" "${server_shell_dir}" "${user}" "${benchmark_shell_dir}" "isoverflow_merge" "LEVEL_COMPACTION" "${start_iotdb}"

#顺序 读写混合测试


#copy 读写顺序的conf
${benchmark_shell_dir}/cp_bm_conf.sh "rw_no_overflow.config.properties"
#启动乱序写入测试
${benchmark_shell_dir}/run_bm.sh "${benchmark_result_dir}/${test_result_path}" rw_no_overflow

#记录执行结果 fail写到fail文件 性能值写到结果文件

${benchmark_shell_dir}/write_fail_and_result.sh "${benchmark_result_dir}/${test_result_path}" "rw_no_overflow.out" "rwmix" "result_rwmix-nooverflow_fail_1" "result_rwmix-nooverflow_1"

#backup config
${benchmark_shell_dir}/bk_bm_conf.sh "${benchmark_result_dir}/${test_result_path}" "rw_no_overflow.config.properties"

#混合顺序测试完成 flush stop-iotdb 备份 清缓存  start-iotdb
${benchmark_shell_dir}/iotdb_stop_bk_clear_param_start.sh "${remote_str}" "${server_shell_dir}" "${user}" "${benchmark_shell_dir}" "rw_nooverflow_merge" "LEVEL_COMPACTION" "${start_iotdb}"

#乱序 读写混合测试

#copy 读写乱序的conf
${benchmark_shell_dir}/cp_bm_conf.sh "rw_is_overflow.config.properties"
#启动乱序写入测试
${benchmark_shell_dir}/run_bm.sh "${benchmark_result_dir}/${test_result_path}" rw_is_overflow

#记录执行结果 fail写到fail文件 性能值写到结果文件

${benchmark_shell_dir}/write_fail_and_result.sh "${benchmark_result_dir}/${test_result_path}" "rw_is_overflow.out" "rwmix" "result_rwmix-isoverflow_fail_1" "result_rwmix-isoverflow_1"

#backup config
${benchmark_shell_dir}/bk_bm_conf.sh "${benchmark_result_dir}/${test_result_path}" "rw_is_overflow.config.properties"

start_iotdb="false"
#混合乱序测试完成 flush stop-iotdb 备份 清缓存  start-iotdb
${benchmark_shell_dir}/iotdb_stop_bk_clear_param_start.sh "${remote_str}" "${server_shell_dir}" "${user}" "${benchmark_shell_dir}" "rw_isoverflow_merge" "NO_COMPACTION" "${start_iotdb}"


#iotdb copy data_isoverflow_nomerge 到$iotdb/data
eval ${remote_str}"${server_shell_dir}/mv_bk_data.sh nooverflow_nomerge"

testcase_file="testcase_list.txt"
#查询测试共24个场景
function  exec_query(){
  for  i  in  `cat ${benchmark_shell_dir}/$testcase_file`
  do
    line=$i
    conf=`echo $line|awk -F ',' '{print $1}'`
    operation=`echo $line|awk -F ',' '{print $2}'`

    #echo $i
    #重启iotdb服务
    ${benchmark_shell_dir}/iotdb_stop_clear_start.sh "${remote_str}" "$server_shell_dir"  "${user}" "${benchmark_shell_dir}"
    #copy 本次测试的config
    ${benchmark_shell_dir}/cp_bm_conf.sh "${conf}.config.properties"
    #执行第1遍查询
    #如果有fail写到fail中 把性能值写到乱序结果文件1
    ${benchmark_shell_dir}/run_bm.sh "${benchmark_result_dir}/${test_result_path}" "$1_${conf}_1"
    ${benchmark_shell_dir}/write_fail_and_result.sh "${benchmark_result_dir}/${test_result_path}" "$1_${conf}_1.out" "${operation}" "result_$1_fail_1" "result_$1_1" 
    
    

    #如果有fail写到fail中 把性能值写到乱序结果文件2
    ${benchmark_shell_dir}/run_bm.sh "${benchmark_result_dir}/${test_result_path}" "$1_${conf}_2"
    ${benchmark_shell_dir}/write_fail_and_result.sh "${benchmark_result_dir}/${test_result_path}" "$1_${conf}_2.out" "${operation}" "result_$1_fail_2" "result_$1_2"
    
    #保存本次的config
    #${benchmark_shell_dir}/bk_bm_conf.sh "${benchmark_result_dir}/${test_result_path}" "${conf}_$1.config.properties"
  done
}
exec_query "nooverflow"

#乱序场景测试完毕,停止iotdb服务
eval ${remote_str}"${server_shell_dir}/stop_iotdb.sh"

#iotdb mv data 保存
eval ${remote_str}"${server_shell_dir}/mv_data_bk.sh nooverflow_nomerge"

#iotdb 数据库所在机器 清操作系统缓存
eval ${remote_str}"${server_shell_dir}/clear_cache.sh"

#iotdb 配置参数
eval ${remote_str}"${server_shell_dir}/set_compaction_strategy.sh NO_COMPACTION"

#iotdb copy data_isoverflow 到$iotdb/data
eval ${remote_str}"${server_shell_dir}/mv_bk_data.sh isoverflow_nomerge"


#执行24个查询场景
exec_query "isoverflow"

#顺序场景测试完毕,停止iotdb服务
eval ${remote_str}"${server_shell_dir}/stop_iotdb.sh"

#iotdb mv data logs 保存
eval ${remote_str}"${server_shell_dir}/mv_data_bk.sh isoverflow_nomerge"

eval ${remote_str}"${server_shell_dir}/clear_cache.sh"


#java 对比本次测试结果与基准结果
#base_id=`tail -1 ${benchmark_shell_dir}/base_result/base_id.txt`
#${benchmark_shell_dir}/write_mail_content.sh "${benchmark_result_dir}/${test_result_path}" ${base_id} ${commit_id}

#发送邮件
#sudo -s <<EOF
#${benchmark_shell_dir}/sendmail_result.sh  ${benchmark_result_dir}/${test_result_path}
#EOF
time2=`date +%s`
time=$(($time2-$time1))
echo "run time :${time} s."
${benchmark_shell_dir}/get_res.sh "${benchmark_result_dir}/${test_result_path}" "${start_time}" "${commit_id}"
