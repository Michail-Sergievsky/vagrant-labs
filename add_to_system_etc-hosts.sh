#!/bin/bash

grep -e ens161 -A1 -e name hosts.yml | awk '/name|ip/ {print $2$3}' | awk '!(NR%2){print$0" "p}{p=$0}' | sed s/name://g > system_hosts_study

while read line; do
    sudo sh -c "echo '$line' >> /etc/hosts"
    echo $line
done < system_hosts_study

rm -fr system_hosts_study
