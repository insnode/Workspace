#!/bin/bash
chmod 777 ipmicfg
gpuid=$(ps -ef | grep gpu.sh | grep grep -vc)

path="/root/Desktop/stresslog/sensor.log"
time=$(date)
#echo ---------Temp----$time------------ | tee $path

./ipmicfg -sdr > $path;
sleep 1;
cpunum=`lscpu | grep Socket | awk -F ": " '{print $2}'`
echo "cpu_temp num = $cpunum"

for ((i=1;i<=$cpunum;i=i+1))
do

  
  arrnum[i]=`cat $path |grep ok -i | grep temp -i|grep 'cpu.temp\|cpu.0\|cpu.1\|cpu.2\|cpu.3\|cpu.4\|cpu0\|cpu1\|cpu2\|cpu3\|cpu4' -i | sed -n "${i},${i}p" | grep '..C/' -io | head -n 1 | awk -F "C/" '{print $1}'`

  echo ${arrnum[i]}
  if [ $i = "1" ];then
   
    tempmax=${arrnum[1]}
   
  else
   
    if [ $tempmax -lt ${arrnum[i]} ];then

      tempmax=${arrnum[i]}
      echo "cpu_max!"
      cat ./sensor_tmp.txt > $path 
     
    fi

  fi  
  
    
 
done

echo $tempmax
sleep 2
for ((i=0;i<=11;i=i+0))
do


   
   time=$(date)
   echo ---------Temp----$time------------
     
     if [ $gpuid != "0" ];then
        
        echo -----GPU------------ 
        nvidia-smi 


     fi
   
   sleep 2
   
   ./ipmicfg -sdr > ./sensor_tmp.txt
   
    for ((i1=1;i1<=$cpunum;i1=i1+1))
    do
    arrnum[i1]=`cat ./sensor_tmp.txt |grep ok -i | grep temp -i|grep 'cpu.temp\|cpu.0\|cpu.1\|cpu.2\|cpu.3\|cpu.4\|cpu0\|cpu1\|cpu2\|cpu3\|cpu4' -i | sed -n "${i1},${i1}p" | grep '..C/' -io | head -n 1 | awk -F "C/" '{print $1}'`
    
     
    if [ $tempmax -lt ${arrnum[i1]} ];then

      tempmax=${arrnum[i1]}
      echo "cpu_max!"
      cat ./sensor_tmp.txt > $path 
     
    fi
    
    done

   
   clear
   echo "-----CPU--最高温度Temp-MAX-${tempmax}C--------"
   cat ./sensor_tmp.txt | grep ok -i | grep temp -i|grep 'cpu.temp\|cpu.0\|cpu.1\|cpu.2\|cpu.3\|cpu.4\|cpu0\|cpu1\|cpu2\|cpu3\|cpu4' -i  
   sleep 2
   cat ./sensor_tmp.txt | grep fan -i 
   
   stress=$(ps -ef | grep all.sh | grep grep -vc)
   
   if [ $stress = "0" ];then
     echo "-----ps -ef | grep all.sh---"
        ps -ef | grep all.sh
        echo "-----ps -ef | grep all.sh| grep grep -vc---"
        ps -ef | grep all.sh | grep grep -vc
       	i=12
   else
    sleep 20
   fi


done

