#!/bin/bashtim
path="$1"
sleep 5
time1=`cat /proc/uptime | cut -d . -f 1`
while (( $(ps -ef | grep 'path_next_stress.sh'| grep grep -vc ) > 0))
do
      
      
      time2=`cat /proc/uptime | cut -d . -f 1`
      #echo $time2
      if (( time2-time1>=120));then
         time1=$((time1+120))
         time=`cat $path | grep 'time="' | head -1| awk -F "=" '{print $2}' | sed "s/\"//g"`
         time=$((time-120))
         #echo $time
         if ((time < 0 ));then
            time=0
         fi 
         s_n1=`cat $path | grep 'time="' -n | head -1|awk -F ":" '{print $1}'`
         sed -i "${s_n1}s#.*#time=\"${time}\"#"   $path
      fi
      sleep 1

done
