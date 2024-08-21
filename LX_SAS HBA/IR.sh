#!/bin/bash
chmod 777 sas3flash 
echo "SAS Address  : 500605B$1"
echo "Assembly     : $2"
echo "Tracer Number: $3"
read -p "any key contui"  input
./sas3flash -o -e 7
clear
./sas3flash -o -f IR.rom
clear
./sas3flash -o -b mptsas3.rom
clear
./sas3flash -o -b mpt3x64.rom
clear
./sas3flash -o -sasadd 500605B$1
./sas3flash -o -assem $2
./sas3flash -o -tracer $3
