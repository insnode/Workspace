#!/bin/bash
#author:r10
#mail:1160053386@qq.com
#release date:2017/7/6
#version:1.0
#department:MFG
if ! id|grep -q "uid=0";then
	echo "error,you must be use root account and exiting..."
	exit 1
fi
\cp -f ./times.log /var/tmp && chmod 777 /var/tmp/times.log && echo "cp times.log to /var/tmp success!"
\cp -f ./reboot.sh /var/tmp && chmod 777 /var/tmp/reboot.sh && echo "cp reboot.sh to /var/tmp success!"
if ! grep -q 'source\ /var/tmp/reboot' /etc/rc.local;then
		echo "source /var/tmp/reboot.sh" >>/etc/rc.local && echo "add reboot.sh to /etc/rc.local success"
fi
echo "_______________________________"
echo
cd /var/tmp && echo "please change to /var/tmp and write times to times.log"
echo "_______________________________"
