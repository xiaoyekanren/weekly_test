benchmark_shell_dir="$( cd "$( dirname "$0"  )" && pwd  )"
benchmark_tool_dir="${benchmark_shell_dir}/../benchmark_tool"

if [ "$#" != 2 ]; then
  echo "please input backup dir and conf name."
  exit 1
fi

dest_conf_dir=$1
orig_conf_dir=${benchmark_tool_dir}/conf
#backup conf
cp -rf ${orig_conf_dir}/config.properties ${dest_conf_dir}/$2
exit 0
