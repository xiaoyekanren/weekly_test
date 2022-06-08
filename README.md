# 一次性周测脚本
1. benchmark->iotdb的免密钥登陆
2. 修改scan_commit.sh第39-40行
```
  sbin_dir=  # 改为iotdb/sbin的绝对路径
  iotdb_dir=  # 改为iotdb的绝对路径
```
3. benchmark存放位置
```
weekly_test/benchmark_script/benchmark_tool
```
4. 修改全部case的配置文件的iotdb地址
```
sed -i -e 's/^HOST=.*/HOST=[The Truth IP]/' weekly_test/benchmark_script/benchmark_shell/weekly_config/*.properties
```
5. 修改