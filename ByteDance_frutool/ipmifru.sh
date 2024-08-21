#!/bin/bash
chmod 777 ipmicfg
txt=`cat $1`
if [ -f $1 ];then


  BM=`echo "$txt" | grep BBMF |grep "#" -v  |awk -F "=" '{print $2}' | sed "s/\"//g"`
  ##判断存在$符号=变量
  ret_s=`echo "$BM" | grep -F '$'| wc -l`
  if [ "$ret_s" = "1" ];then
     #去除空格以及 “号后以$分割
     ret_dmiA=`echo $BM | sed "s/\"//g"| cut -d $ -f 2`
     #sleep 11
     BM=`echo "$txt" | grep "^${ret_dmiA}" |awk -F "=" '{print $2}' | sed "s/\"//g"`
  fi


  BPN=`echo "$txt" | grep BBPD |grep "#" -v |awk -F "=" '{print $2}'| sed "s/\"//g"`
  
  if [ ! $BPN ];then
     BPN=`dmidecode -t2 | grep "Product Name" | awk -F ": " '{print $2}'| sed "s/\"//g"`
  else
     ##判断存在$符号=变量
    ret_s=`echo "$BPN" | grep -F '$'| wc -l`
    if [ "$ret_s" = "1" ];then
     #去除空格以及 “号后以$分割
     ret_dmiA=`echo $BPN | sed "s/\"//g"| cut -d $ -f 2`
     #sleep 11
     BPN=`echo "$txt" | grep "^${ret_dmiA}" |awk -F "=" '{print $2}' | sed "s/\"//g"`
    fi
  fi

  BS=`dmidecode -t2 | grep "Serial Number" | awk -F ": " '{print $2}'| sed "s/\"//g"`

  PM=`echo "$txt" | grep SYMF |grep "#" -v |awk -F "=" '{print $2}'| sed "s/\"//g"`
  ret_s=`echo "$PM" | grep -F '$'| wc -l`
  if [ "$ret_s" = "1" ];then
     #去除空格以及 “号后以$分割
     ret_dmiA=`echo $PM | sed "s/\"//g"| cut -d $ -f 2`
     #sleep 11
     PM=`echo "$txt" | grep "^${ret_dmiA}" |awk -F "=" '{print $2}' | sed "s/\"//g"`
  fi
  
  PN=`echo "$txt" | grep SYPD |grep "#" -v |awk -F "=" '{print $2}'| sed "s/\"//g"`
  ret_s=`echo "$PN" | grep -F '$'| wc -l`
  if [ "$ret_s" = "1" ];then
     #去除空格以及 “号后以$分割
     ret_dmiA=`echo $PN | sed "s/\"//g"| cut -d $ -f 2`
     #sleep 11
     PN=`echo "$txt" | grep "^${ret_dmiA}" |awk -F "=" '{print $2}'| sed "s/\"//g" `
  fi

  PS=`echo "$txt" | grep SYSN |grep "#" -v |awk -F "=" '{print $2}'| sed "s/\"//g"`
  ret_s=`echo "$PS" | grep -F '$'| wc -l`
  if [ "$ret_s" = "1" ];then
     #去除空格以及 “号后以$分割
     ret_dmiA=`echo $PS | sed "s/\"//g"| cut -d $ -f 2`
     #sleep 11
     PS=`echo "$txt" | grep "^${ret_dmiA}" |awk -F "=" '{print $2}' | sed "s/\"//g"`
  fi

  CS=`echo "$txt" | grep CHSN |grep "#" -v |awk -F "=" '{print $2}'| sed "s/\"//g"`
  ret_s=`echo "$CS" | grep -F '$'| wc -l`
  if [ "$ret_s" = "1" ];then
     #去除空格以及 “号后以$分割
     ret_dmiA=`echo $CS | sed "s/\"//g"| cut -d $ -f 2`
     #sleep 11
     CS=`echo "$txt" | grep "^${ret_dmiA}" |awk -F "=" '{print $2}' | sed "s/\"//g"`
  fi
fi

echo -e "  BM=$BM \n  BPN=$BPN \n  BS=$BS \n  PM=$PM \n  PN=$PN \n  PS=$PS \n  CS=$CS "

sleep 2
if [ $BM ];then
./ipmicfg -fru BM $BM
fi
if [ $BPN ];then
./ipmicfg -fru BPN $BPN
fi
if [ $BS ];then
./ipmicfg -fru BS $BS
fi
if [ $PM ];then
./ipmicfg -fru PM $PM
fi
if [ $PN ];then 
./ipmicfg -fru PN $PN
fi
if [ $PS ];then
./ipmicfg -fru PS $PS
fi
if [ $CS ];then
./ipmicfg -fru CS $CS
fi
