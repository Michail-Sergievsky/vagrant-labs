#!/bin/bash
while read line; do
	args=($line)
	sshpass -p student ssh-copy-id -f -o StrictHostKeyChecking=no -i /home/student/.ssh/id_rsa.pub student@${args[0]}
done < hosts.txt
