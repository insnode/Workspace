#!/bin/bash
path="$2"
if [ ! -d /root/Desktop/stresslog ];then
   mkdir /root/Desktop/stresslog

fi


sleep 30

for ((i=0;i<120;i=i+1))
do
    ret=`ps -ef | grep gnome  | grep grep -vc` #
    if (($ret>=2));then  #等待桌面加载完成
        sleep 10
        break
    fi
    sleep 1
done
sh $path/run-stress.sh $1
if [ $4 ];then
     timeA="$4"
     time1=$(cat  /root/Desktop/stresslog/stress.log |  grep "in " |awk '{print $8}')
     
     rnd=$(($RANDOM %12+0))  # TIME 0-12
     
     
    
     time2=$((timeA+${rnd}))"s"
    
     #echo $time2
     sed -i "s/$time1/$time2/g" /root/Desktop/stresslog/stress.log  #替换时间
     sync
fi
sleep 1
sh $path/list.sh;
sleep 1

ret=`cat /etc/rc.d/rc.local | grep "stress" | grep '.sh' |awk -F "/" '{print $NF}' `



for i in $ret
do
  
  sed -i "/${i}/ d" /etc/rc.d/rc.local
  
done

##自动关机
if [ "$3" = "1" ];then
   
   sleep 10  ##kill pid 防止run-stress在前被杀死后直接关机
   echo poweroff
   poweroff
fi

