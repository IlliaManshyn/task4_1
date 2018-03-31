 #!bin/bash

MANUFACT="$(dmidecode -s baseboard-manufacturer)"
PRODUCTNUM="$(dmidecode -s baseboard-product-name)"
way="$( cd "$( dirname "$0" )" && pwd )"

echo "---Hardware---" > $way/task4_1.out
(lscpu | grep -iT "Model name" | sed 's/Model name:/CPU:/' | sed 's/\s\+/ /') >> $way/task4_1.out 
(grep -iT "MemTotal" /proc/meminfo | sed 's/MemTotal:/RAM:/') | sed 's/\s\+/ /' >> $way/task4_1.out

if [[ -n $MANUFACT && -n $PRODUCTNUM ]]
	then
	(echo -n "Motherboard: "; echo "$MANUFACT/$PRODUCTNUM ") >> $way/task4_1.out
	elif [ -n "$MANUFACT"  ]
	then
	(echo -n "Motherboard: "; echo "$MANUFACT/Unknown") >> $way/task4_1.out
	elif [ -n "$PRODUCTNUM" ]
	then
	(echo -n "Motherboard: "; echo "Unknown/$PRODUCKTNUM") >> $way/task4_1.out
	else
	(echo -n "Motherboard: "; echo "Unknown/Unknown") >> $way/task4_1.out
fi

(echo -n "System Serial Number: "; dmidecode -s system-serial-number) >> $way/task4_1.out 
echo "---System---" >> $way/task4_1.out 
grep -i "distrib_description" /etc/lsb-release | sed 's/DISTRIB_DESCRIPTION=/OS Distribution: /' | sed "s/\"//g" >>  $way/task4_1.out 
(echo -n "Kernel version: "; uname -r) >> $way/task4_1.out 
(echo -n "Installation date:"; tune2fs -l /dev/sda1 | grep -i "filesystem created" | cut -sd  ':' -f2,3,4,5 | sed 's/\s\+/ /') >> $way/task4_1.out 
(echo -n "Hostname: "; hostname) >> $way/task4_1.out 
(echo -n "Uptime:"; uptime -p | cut -d 'p' -f2) >> $way/task4_1.out 
(echo -n "Processes running: "; ps -e |grep -v "PID"| wc -l) >> $way/task4_1.out
(echo -n "User logged in: "; who | cut -d ' ' -f1 | wc -l) >> $way/task4_1.out
echo "---Network---" >> $way/task4_1.out
NUMBEROFINT=$(cat /proc/net/dev | cut -sd ':' -f1| wc -l)
for ((i=1; i <= $NUMBEROFINT ; i++ ))
do
INTNAME=$(ip -br a | sed 's/\s\+/,/g' | cat -n | cut -d ',' -f1 | grep $i|cut -f2)
ISIT=$(ifconfig  $INTNAME | grep  "inet addr")
if [ "$ISIT" ]
then
ip -br address show $INTNAME | sed 's/\s\+/,/g' | cut -d ',' -f1,3 | sed 's/,/: /' | sed 's/\s\+/ /' >> $way/task4_1.out
continue
else
echo  "$INTNAME: -/-" >> $way/task4_1.out
fi
done
