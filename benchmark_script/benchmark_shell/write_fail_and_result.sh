
# $1是path $2是需要解析的结果文件名 $3是操作类型 $4是fail文件名 $5是性能结果文件名
if [ "$#" != 5 ]; then
  echo "Please input result_path,result_file,Operation,save_fail_file,save_res_file ,test_num,line_num,commit_id ." >> ${server_log}
  exit 1
fi

result_path=$1
result_file=$2
operation=$3
save_fail_file=$4
save_perf_file=$5
testcase=`echo ${result_file}|awk -F '.' '{print $1}'`

if [ "$operation" = "INGESTION" ]; then
  throughput=`tail -50 ${result_path}/${result_file} |grep INGESTION|head -1|awk '{print $6}'`
  echo "${throughput}" >> ${result_path}/${save_perf_file}
fi

if [ "$operation" = "rwmix" ]; then
  throughput=`tail -50 ${result_path}/${result_file} |grep INGESTION|head -1|awk '{print $6}'`
  echo "${throughput}" >> ${result_path}/${save_perf_file}
  avg_p95=`tail -12 ${result_path}/${result_file}  |grep -v -|awk '{print $2,$9}'`
  echo "${avg_p95}" >> ${result_path}/${save_perf_file}
  fail_res=`grep -A 11 'okOperation' ${result_path}/${result_file} |grep -v okOperation|awk '$4>0{print $1"-failOperation="$4}'`
  if [ "$fail_res" != "" ]; then
    echo "$fail_res" >> ${result_path}/${save_fail_file}
  fi 
  exit 0
  
fi


failOper=`tail -50 ${result_path}/${result_file} |grep ${operation} | head -1|awk '{print $4}'`
if [ "$failOper" != 0 ]; then
  echo "${testcase}:failOperation=${failOper}" >> ${result_path}/${save_fail_file}
fi

avg_time=`tail -50 ${result_path}/${result_file} |grep -w ${operation} | tail -1|awk '{print $2,$9}'`
echo "${avg_time}" >> ${result_path}/${save_perf_file}

#p95_time=`tail -50 ${result_path}/${result_file} |grep -w ${operation} | tail -1|awk '{print $9}'`
#echo "${p95_time}" >> ${result_path}/${save_perf_file}

