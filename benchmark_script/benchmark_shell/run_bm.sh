benchmark_shell_dir="$( cd "$( dirname "$0"  )" && pwd  )"
benchmark_tool_dir="${benchmark_shell_dir}/../benchmark_tool"
if [ "$#" != 2 ]; then
  echo "please input result file path and result file name."
  exit 1
fi
res_path=$1
res_file=$2
bm_dir=${benchmark_tool_dir}
#执行测试 把结果文件输出到文件
#echo $res_path
#echo $res_file
cd ${bm_dir}
./benchmark.sh > ${res_path}/${res_file}.out 
exit 0
