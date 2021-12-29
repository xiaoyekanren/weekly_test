#!/bin/bash
dir="$( cd "$( dirname "$0"  )" && pwd  )"

if [ $# != 3 ]
then
   echo "Please enter the result dir and target result file and commit_id. "
   exit
fi
res_dir=$1
exp=`egrep -i "Exception|ERROR" ${res_dir}/*.out`
res_file="${dir}/result/$2_res.csv"
fail_file="${dir}/result/$2_fail.log"
tmp_res="${dir}/result/$2_tmp.out"

commit_id=$3
if [ "${exp}x" = "x" ]
then
   echo "No exception."
else

   echo "${res_dir} has test Exception.">> "${fail_file}"
fi
function Q1_Q10()
{
    for i in {1..10}
    do
       echo "Q$i">> ${res_file}
    done
}
function query_sql()
{
   if [ -f "${dir}/testcase_list.txt" ];then
      cat ${dir}/testcase_list.txt |awk -F ',' '{if(length($1)==0){print "null";}else{print $1}}'>>${res_file}
   else
      echo "${dir}/testcase_list.txt does not exist." >> "${fail_file}"
   fi
}
function write_info()
{
   echo "write throughput(point/s)"  > ${res_file}
   echo "commit_id   " >> ${res_file}
   echo "seq" >> ${res_file}
   echo "unseq" >> ${res_file}
   echo "rw-seq" >> ${res_file}
   echo "rw-unseq" >> ${res_file}
   echo "seq-read_1" >> ${res_file}
   echo "commit_id   " >> ${res_file}
   query_sql
   echo "seq-read_2" >> ${res_file}
   echo "commit_id   " >> ${res_file}
   query_sql
   echo "unseq-read_1" >> ${res_file}
   echo "commit_id   " >> ${res_file}
   query_sql
   echo "unseq-read_2" >> ${res_file}
   echo "commit_id   " >> ${res_file}
   query_sql
   echo "rw-seq_read" >> ${res_file}
   echo "commit_id   " >> ${res_file}
   Q1_Q10
   echo "rw-unseq_read" >> ${res_file}
   echo "commit_id   " >> ${res_file}
   Q1_Q10
}

function tmp_res()
{
   echo "aa" > $tmp_res
   echo "$commit_id" >> $tmp_res
   cat ${res_dir}/result_nooverflow_1 |head -1 >> $tmp_res
   cat ${res_dir}/result_isoverflow_1 |head -1 >> $tmp_res
   cat ${res_dir}/result_rwmix-nooverflow_1 |head -1 >> $tmp_res
   cat ${res_dir}/result_rwmix-isoverflow_1 |head -1 >> $tmp_res
   echo "aa" >> $tmp_res
   echo "$commit_id" >> $tmp_res
   cat ${res_dir}/result_nooverflow_1 |awk '{if(NR>2){print $1}}'|awk '{if(length($1)==0){print "null";}else{print $1}}' >> $tmp_res
   echo "aa" >> $tmp_res
   echo "$commit_id" >> $tmp_res
   cat ${res_dir}/result_nooverflow_2 |awk '{if(length($1)==0){print "null";}else{print $1}}' >> $tmp_res
   echo "aa" >> $tmp_res
   echo "$commit_id" >> $tmp_res
   cat ${res_dir}/result_isoverflow_1 |awk '{if(NR>2){print $1}}'|awk '{if(length($1)==0){print "null";}else{print $1}}' >> $tmp_res
   echo "aa" >> $tmp_res
   echo "$commit_id" >> $tmp_res
   cat ${res_dir}/result_isoverflow_2 |awk '{if(length($1)==0){print "null";}else{print $1}}' >> $tmp_res
   echo "aa" >> $tmp_res
   echo "$commit_id" >> $tmp_res
   grep -A 12 -i "Latency (ms) Matrix" ${res_dir}/rw_no_overflow.out |grep -A 10 -i "PRECISE_POINT" |awk '{if(length($2)==0){print "null";}else{print $2}}' >> $tmp_res
   echo "aa" >> $tmp_res
   echo "$commit_id" >> $tmp_res
   grep -A 12 -i "Latency (ms) Matrix" ${res_dir}/rw_is_overflow.out |grep -A 10 -i "PRECISE_POINT" |awk '{if(length($2)==0){print "null";}else{print $2}}' >> $tmp_res
}
function append_res()
{
   line_num=1
   for  i  in  `cat ${tmp_res}`
   do
      if [ "$i"x = "aax" ];then
         let line_num++
      else
         str=",$i"
         sed -i "${line_num}s/$/${str}&/"  ${res_file}
         let line_num++
      fi
   done
}

function write_res()
{
   if [ ! -f ${res_file} ];then
      write_info
      tmp_res
      append_res
   else
      tmp_res
      append_res
   fi
}

write_res

