#!/bin/bash
#launch in vagrant folder
# creating ansible inventory file, use yml hosts file as argument for script

hosts="hosts.yml"
echo "[$hosts]" > ansible_inventory_$hosts
# echo "$hosts"
grep -E -A1 'name|ens161' $hosts | awk '/name|ip/{print $NF}' | awk '{printf (NR%2==0) ? " ansible_host=" $0 "\n" : $0}' >> ansible_inventory_$hosts

