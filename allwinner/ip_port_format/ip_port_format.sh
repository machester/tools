#!/bin/bash
FILE_NAME=after_change.txt
START_HEAD=`echo "add action=dst-nat chain=dstnat dst-port="`
SET_PROTOCOL=`echo "protocol=tcp to-addresses="`
TO_PORTS=`echo "to-ports="`


function help() {
    echo "------------ help -----------"
    echo "input format: ./ip_port_change.sh file.txt"
}


echo "-------------- start convert --------------"


sleep 2s

if [ $# -lt 1 ]; then
	help
fi

echo $1

echo > $FILE_NAME

for line in `cat $1`
do
    echo $line > tmp.txt
      echo "---> transform:"
      echo "before: "$line
      IP_ADDRESS=`awk -F ":" '{print $1}' tmp.txt`
      DNS_PORT=`awk -F ":" '{print $2}' tmp.txt`
      echo $START_HEAD$DNS_PORT" "$SET_PROTOCOL$IP_ADDRESS" "$TO_PORTS$DNS_PORT >> $FILE_NAME
      
done
