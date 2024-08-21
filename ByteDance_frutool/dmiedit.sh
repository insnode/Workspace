#!/bin/bash

read -p "更新远程 fru? y/n " input 

chmod 777 sum

./sum -c getdmiinfo --file .dmitmp.txt --overwrite




###判断是否为文件 如果不是文件直接查找对象进行更改
if [ -f ./$1 ]; then
 clear
 echo "注意使用SUM工具刷新BIOS后需要重启再运行 否则更新FRU会失败"
 echo "下面将按照对应的txt文本，更新FRU"
 txt=`cat $1`
 all_n=`cat $1| wc -l`
 #echo -e '$1 is file'
 #echo $all_n
 echo "需要被更改的选项为："
 for ((i=1;i<=$all_n;i=i+1))
 do
     ###获取要修改的项
     arr_dmi[i]=`echo "$txt"  | sed -n "$i,${i}p" | awk -F "=" '{print $1}'`
     
     ###去除多余空格
     arr_dmi[i]=`echo ${arr_dmi[i]}`
     
     #echo ${#arr_dmi[i]}
     ##等于四个字符才会进行查找替换
     

      
     ###获取四个字符所在行数###查找到才会进行操作
     ret_n=$(cat ./.dmitmp.txt | grep -F "{${arr_dmi[i]}}" -n | awk -F ":" '{print $1}')
     if [ $ret_n ] && [ "${#arr_dmi[i]}" = "4" ];then

        echo -n "${arr_dmi[i]}=" 
        ###获取导出的txt行文本
        get_n=`cat .dmitmp.txt | grep ${arr_dmi[i]}`
     
        ###获取fru.txt中要修改的值
     
        get_dmiA=`cat $1  | sed -n "$i,${i}p" | awk -F "=" '{print $2}'`
        
        ##判断是否存在$字符 如果存在则去找$后面字符（例如MN）对应的值
        ret_s=`echo "$get_dmiA" | grep -F '$'| wc -l`
        if [ "$ret_s" = "1" ];then
           #去除空格以及 “号后以$分割
           ret_dmiA=`echo $get_dmiA | sed "s/\"//g"| cut -d $ -f 2`
           if [ "${arr_dmi[i]}" = "SYVS" ] || [ "${arr_dmi[i]}" = "CHVS" ];then
              if [ "$ret_dmiA" = "AUTO" ];then
                 get_dmiA=`dmidecode -t0 | grep "Version" | awk -F ": "  '{print $2}'`
                 #加上双引号
                 get_dmiA=`echo " \"$get_dmiA\""`
              else
                get_dmiA=`echo "$txt" | grep "${ret_dmiA}" | grep "#" -v |head -1  |awk -F "=" '{print $2}' `
              fi
           else
           
           get_dmiA=`echo "$txt" | grep "${ret_dmiA}" | grep "#" -v |head -1  |awk -F "=" '{print $2}' `
           fi
        
        fi
        echo -n -e "$get_dmiA\n"
        #echo -e "\n" 
        ###获取被修改的qianduan

        get_dmiB=`echo "$get_n" | awk -F "=" '{print $1}'`
        #get_dmiB="\""${get_dmiB}"\""
        #echo $get_dmiB
       
        ###组成修改后的行
        edit_n="${get_dmiB}=${get_dmiA}"
        #echo $edit_n 
       
        sed -i "${ret_n},${ret_n}c ${edit_n}" .dmitmp.txt   

     fi
     
 done
 
 if [ "$input" = "y" ] || [ "$input" = "Y" ];then

 bash ipmifru.sh $1


 fi
else
  
  if [ $1 ];then
     if [ $2 ];then
        
        ####$1=SYMF  $2="OEM"
        clear
        echo "单独更改edit $1"
        
        ###获取对象所在行数###
     
        ret_n=$(cat ./.dmitmp.txt | grep $1 -n | awk -F ":" '{print $1}')
        if [ $ret_n ];then


           ###获取行文本
           get_n=`cat .dmitmp.txt | grep $1`
           
           ###获取被修改的qianduan

           get_dmiB=`echo "$get_n" | awk -F "=" '{print $1}'`
           
           #echo $get_dmiB
           ###组成修改后的行
           #edit_n=`echo "$get_n"|sed "s/${get_dmiB}/\"$2\"/g"`
           edit_n="${get_dmiB}=\"$2\""
           #echo $edit_n 
           
           sed -i "${ret_n},${ret_n}c ${edit_n}" .dmitmp.txt   

        fi
        


    
     fi
  else
    echo input option erro
    
  fi

 
fi




./sum -c changedmiinfo --file .dmitmp.txt 


echo end

