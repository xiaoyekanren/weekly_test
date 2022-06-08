#!/bin/bash
if [ "$#" != 1 ]; then
  echo "please input sleep time."
  exit 1
fi

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
iotdb_soft_dir=$DIR/../iotdb_test
sleep_time=$1
last_commit_dir=${iotdb_soft_dir}/last_commit
commit_id_file="commit_id.txt"

pull_num=0
max_compile=3
cur_compile=0

mvn_package()
{
  cd ${iotdb_soft_dir}
  while [ $cur_compile -lt $max_compile ] 
  do
      echo "${commit_id}" >> $DIR/${commit_id_file}
      cp -rp "${last_commit_dir}" "${iotdb_soft_dir}/iotdb_${commit_id}"
      cd "${iotdb_soft_dir}/iotdb_${commit_id}"
      mvn clean package -DskipTests
      if [ "$?" != 0 ]; then
        echo "mvn clean package fail."
        let cur_compile++
      else
         echo "mvn clean package success."
         break
      fi
 done
}

set_env()
{
  #获取server的安装路径,设置环境变量
  # sbin_dir=`find ${iotdb_soft_dir}/iotdb_${commit_id}/distribution/target/ -name sbin|grep "SNAPSHOT-server-bin"`
  # iotdb_dir=`echo "${sbin_dir}"|awk -F 'sbin' '{print $1}'`
  sbin_dir=/home/cluster/standalone_0.13/iotdb-0.13.1-0608-407d4bb1c0/sbin
  iotdb_dir=/home/cluster/standalone_0.13/iotdb-0.13.1-0608-407d4bb1c0
  . ~/.bashrc
  echo "export iotdb_dir=$iotdb_dir" > ${DIR}/env.sh
  echo "export PATH=${sbin_dir}:$PATH" >> ${DIR}/env.sh
}
git_pull()
{
  cd ${last_commit_dir}
  while [ 0 -eq $pull_num ]
  do

    gp_str=`git pull`
    echo $gp_str
    res_newest=$(echo $gp_str | grep "Already up-to-date.")
    res_upd=$(echo $gp_str | grep "Updating ")
    #无更新 
    if [[ "$res_newest" != "" ]]; then
      sleep $sleep_time
    #有更新 
    elif [[ "$res_upd" != "" ]]; then
      #记录本次测试版本的commit id
      commit_id=`git log --pretty=tformat:'%ci %h'|head -1|awk -F ' ' '{print substr($1,6,5)"_"$4}'`
      mvn_package
      #设置iotdb的环境变量
      set_env
      pull_num=1
    #有错误
    else
      sleep 2m
    fi
  done 
}
#调用
# git_pull
set_env
