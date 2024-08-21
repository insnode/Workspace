#!/bin/bash
chmod 777 storcli64
if [ $1 ];then
   sleep1="$1"
else
   sleep1=0.3
  
fi
EID=`./storcli64 /c0 show | grep "^EID State" -A 2 | sed -n '3,3p' | awk '{print $1}'`
drives=`./storcli64 /c0 show | grep "Physical Drives" | cut -d = -f 2`
drives=`echo $drives`
while ((1))
do
  for ((n=0;n<drives;n++))
  do
  ./storcli64 /c0/"e$EID"/s$n start locate >>/dev/null

  done

  sleep 2

  for ((n=0;n<drives;n++))
  do
  ./storcli64 /c0/"e$EID"/s$n stop locate >>/dev/null
 
  done

   sleep 1

for ((i=0;i<3;i++))
do
  for ((n=0;n<drives;n++))
  do
  ./storcli64 /c0/"e$EID"/s$n start locate >>/dev/null
  sleep $sleep1


  ./storcli64 /c0/"e$EID"/s"$((n-1))" stop locate >>/dev/null
  if ((n==$drives-1));then
  ./storcli64 /c0/"e$EID"/s"$n" stop locate >>/dev/null
  fi
  done
  sleep $sleep1

  for ((n=drives-1;n>=0;n=n-1))
  do 
  ./storcli64 /c0/"e$EID"/s$n start locate >>/dev/null
  sleep $sleep1

  ./storcli64 /c0/"e$EID"/s"$((n+1))" stop locate >>/dev/null
  if ((n==0));then
     ./storcli64 /c0/"e$EID"/s"$n" stop locate >>/dev/null
  fi
  
  done
  sleep $sleep1
done
done
