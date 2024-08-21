#!/bin/bash
lsblk > /root/Desktop/stresslog/hdd.log 
sleep 2
lspci |grep -i eth >/root/Desktop/stresslog/eth.log 
sleep 2
dmidecode -t memory >/root/Desktop/stresslog/mem.log 
sleep 2
lscpu >/root/Desktop/stresslog/cpu.log  
sleep 2
lspci >/root/Desktop/stresslog/lspci.log
