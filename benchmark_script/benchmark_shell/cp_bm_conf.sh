benchmark_shell_dir="$( cd "$( dirname "$0"  )" && pwd  )"
benchmark_tool_dir="${benchmark_shell_dir}/../benchmark_tool"

if [ "$#" != 1 ]; then
  echo "please input orig conf name."
  exit 1
fi

orig_conf_dir=${benchmark_shell_dir}/weekly_config
dest_conf_dir=${benchmark_tool_dir}/conf
#删除原来的config.properties
rm -rf ${dest_conf_dir}/config.properties
#copy conf
cp -rf ${orig_conf_dir}/$1 ${dest_conf_dir}/config.properties
exit 0
