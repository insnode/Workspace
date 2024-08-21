path="/run/media/root/YUAN/0atool/nextboot_stress0424"
name="stress_nextboot.sh"
poweroff="0"
timeA="120"
time="0"
auto="1"


#echo $name
ret=`cat /etc/rc.d/rc.local | grep "${name}" -c`

if (( $ret >= 1 )) && [ "$1" = "1" ];then

   


   echo "stress_time=${time}s"


   echo -e "\033[32m已存在开机自动运行命令 即将运行stress \nsh top_stress.sh 停止并清除开机自动\033[0m"
   if [ "$auto" = "1" ];then

   nohup sh $path/path_next_stress.sh $time $path $poweroff $timeA&
   nohup sh $path/outtime_stress.sh $path/$name &  
   else
   nohup sh $path/path_next_stress.sh $time $path $poweroff &
   echo "del \"source $path/${name} >>/etc/rc.d/rc.local\""
   sed -i "/${name}/ d" /etc/rc.d/rc.local
   fi
else
  for ((i=0;i<2;i=i+1))
  do
  
  ret=`rpm -qa | grep stress -c`
  if [ "$ret" = "0" ];then
     if [ -f ./stress*.rpm ];then
        clear
        echo -e "\033[32m开始安装stress😁😁\033[0m"
        sleep 2
        chmod 777 stress*.rpm
        rpm -ivh stress*.rpm
        
     else
        echo -e "\033[31m没有安装stress 当前目录下没有找到可安装的rpm😠😡\033[0m"
        kill $$
     fi
  else
     if [ "$i" = "1" ];then
        echo -e "\033[31mstress安装完成\033[0m"
     fi
     break
  fi
  done
  systemctl enable rc-local.service
  chmod 777 /etc/rc.d/rc.local
  
  path=`pwd`
  name="$0"
  
  echo 😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋
  read -p "老化完成后自动关机？ y/n 🔌🔌 " input
  if [ "$input" = "y" ] || [ "$input" = "Y" ];then
   poweroff=1
  else
   poweroff=0
  fi
  s_n11=`cat $path/$name | grep "poweroff=" -n | head -1|awk -F ":" '{print $1}'`
  
  
  
  echo 👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍
  read -p "老化时间 h1表示1小时 m60表示60分钟 默认秒 h1=m60=3600 🕙🕙 " input
  time="$input"
  ret_h=`echo "$time" | grep "h" -c`
  ret_m=`echo "$time" | grep "m" -c`
  if [ "$ret_h" = "1" ];then
       ss1=`echo "$time" | awk -F "h" '{print $2}'`
       time=`echo "scale=0;$ss1*3600" |bc |awk -F "." '{print $1}'`
  else
      if [ "$ret_m" = "1" ];then
         ss1=`echo "$time" | awk -F "m" '{print $2}'`
         time=`echo "scale=0;$ss1*60" |bc |awk -F "." '{print $1}'`
      fi
  fi
  s_n12=`cat $path/$name | grep "time=" -n | head -1|awk -F ":" '{print $1}'`
  
  s_n13=`cat $path/$name | grep "timeA=" -n | head -1|awk -F ":" '{print $1}'`
  
  
  echo 😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋😋
  read -p "意外断电重启系统后接着跑 直到跑完设定的时间？ y/n 🔌🔌 " input
  if [ "$input" = "y" ] || [ "$input" = "Y" ];then
   auto=1
  else
   auto=0
  fi
  s_n14=`cat $path/$name | grep "auto=" -n | head -1|awk -F ":" '{print $1}'`
  

  
  s_n1=`cat $path/$name | grep "path=\"" -n | head -1|awk -F ":" '{print $1}'`
  s_n2=`cat $path/$name | grep "name=\"" -n | head -1|awk -F ":" '{print $1}'`
  
  #echo $s_path
  #s_path=`cat $path/1.txt | grep "path=\"" | head -1 |awk -F "=" '{print $2}' | sed "s/\"//g"`
  
  
  sed -i "${s_n1}s#.*#path=\"${path}\"#"   $path/$name
  sed -i "${s_n2}s#.*#name=\"${name}\"#"   $path/$name
  
  sed -i "${s_n11}s#.*#poweroff=\"${poweroff}\"#"   $path/$name
  sed -i "${s_n12}s#.*#time=\"${time}\"#"   $path/$name
  sed -i "${s_n13}s#.*#timeA=\"${time}\"#"   $path/$name
  sed -i "${s_n14}s#.*#auto=\"${auto}\"#"   $path/$name
  #sync

  ret=`cat /etc/rc.d/rc.local | grep "stress" | grep '.sh' |awk -F "/" '{print $NF}' `

  for i in $ret
  do
  
     sed -i "/${i}/ d" /etc/rc.d/rc.local
  
  done

  echo "source ${path}/${name} 1" >> /etc/rc.d/rc.local
  #echo "source ${path}/${name} >>/etc/rc.d/rc.local"
  echo -e "\033[32m将在下一次进入系统时自动开始后台stress老化\033[0m"
  if [ "$poweroff" = "1" ];then
     echo -e "\033[33m 老化时间$time ：完成后自动关机\033[0m"
  else
     echo -e "\033[33m 老化时间$time\033[0m"
  fi
  if [ "$auto" = "1" ];then

     echo -e "\033[31m 意外断电后进入系统接着跑\033[0m"
  fi

fi
