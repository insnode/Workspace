#!/bin/bash
date
if [ ! -d /root/Desktop/stresslog ];then
   mkdir /root/Desktop/stresslog

fi
ret=$(nvidia-smi -L |  grep uuid -ic)   

if [ $ret != "0" ];then
echo "找到本机NVIDIA GPU卡：$ret张" 

read -p "是否运行GPU老化? y/n   " gpu
  if [[ $gpu = "y" ]];then

    read -p "输入GPU老化时间 单位：秒   " s1
    echo "GPU老化时间$s1"
    echo ------开启新的窗口运行GPU老化-------
    gnome-terminal -t "GPU" -x bash -c "source gpu.sh $s1;exec bash;"
    
  
  fi
fi


read -p "-----输入stress老化时间 单位 秒 :" s2
echo "老化时间$s2"
sleep 1
clear
echo -----正在运行stress------------------
gnome-terminal -t "Temp" -x bash -c "sh sensor.sh 1;exec bash;"
sh run-stress.sh $s2
sleep 20
sh list.sh;
sleep 10
clear
echo “stress老化时间结束”
