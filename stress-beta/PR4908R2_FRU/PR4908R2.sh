#!/bin/bash
MN="Powerleader"
PN="PR4908R"

ipmitool fru list

bs=`ipmitool fru | grep "Board Serial" | awk -F  ": " '{print $2}'`
if [ ${#bs} > 0 ];then
  echo -e "主板sn:${bs}\n"
  read -p "输入序列号: "  input 
  psn=$input
  
else
  echo "没有找到主板序列号 检查ipmitool 是否安装"

  read -p "exit" input
  
  echo "没有找到主板序列号 检查ipmitool 是否安装"
  

fi
###导入fru_文件

ipmitool fru write 0 X7440A0_Dhyana2_BAODE.bin

ipmitool fru edit 0 field b 0 $MN

ipmitool fru edit 0 field b 2 $bs

ipmitool fru edit 0 field p 0 $MN

ipmitool fru edit 0 field p 1 $PN

ipmitool fru edit 0 field p 4 $psn 

ipmitool fru list
 
 
