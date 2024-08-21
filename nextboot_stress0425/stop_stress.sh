#!/bin/bash
path=`pwd`

arr_stress=`ps -ef| grep stress | grep -v 'grep\|stop_stress.sh' | awk '{print $2}'`  ##不要干死自己

for i in $arr_stress
do
   kill $i

done

ret=`cat /etc/rc.d/rc.local | grep "stress" | grep '.sh' |awk -F "/" '{print $NF}' `



for i in $ret
do
  
  sed -i "/${i}/ d" /etc/rc.d/rc.local
  
done




