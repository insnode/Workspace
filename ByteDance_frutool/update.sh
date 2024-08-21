#!/bin/bash
clear
if [ "$1" == "BIOS" ] || [ "$1" == "bios" ] || [ "$1" == "BMC" ] || [ "$1" == "bmc" ];then
 
 if [ "$1" == "bios" ] || [ "$1" == "BIOS" ];then
    update="updatebios"
    echo "将要进行BIOS更新"
 else
    update="updatebmc"
    echo "将要进行BMC更新"
 fi
 
 if [ -f $2 ] && [ $2 ];then

  
  chmod 777 sum

  
  ret_bn=`dmidecode -t2 | grep "H12\|X12" -i | wc -l`
  if (($ret_bn >0));then
    
    echo -e " 主板为超微GPU平台 需要更改远程密码 \n 5秒后自动更改为ByteDance@BD"
    
    chmod 777 ipmicfg
    ./ipmicfg -user list
    sleep 5
    
    user_ID=`./ipmicfg -user list | grep Administrator | awk -F "|" '{print $1}'`
    user_name=`./ipmicfg -user list | grep Administrator | awk -F "|" '{print $2}'`
    ./ipmicfg -user setpwd $user_ID ByteDance@BD
    ./sum -I Redfish_HI -u $user_name -p ByteDance@BD -c "$update" --file $2
  else
    echo "常规主板刷新 5s start"
    sleep 5
    ./sum -c "$update" --file $2
  fi
 else
  
  echo "没有指定正确的文件"
 fi
else
  echo -e " 没有指定刷bios还是bmc \n 格式 sh update.sh bios bios.bin \n sh update.sh bmc bmc.bin"
fi
    
