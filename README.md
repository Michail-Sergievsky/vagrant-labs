# Vagrant

Russian repo for distro
<br>
https://vagrant.elab.pro

+ 2 hosts - centos7
+ 2 hosts - centos8
+ 2 hosts - ubuntu2004

Every hosts has 4 partition:
<br>
1 - root partition 40 GB
<br>
3 more partition with 5 GB
<br>

Create remote user student
<br>
Send public ssh-key from user that create machines to student
<br>
Custom .bashrc, .bash_profile for student
<br>
Fixed Centos 8 repo

## TO DO

Add tmux install
Centos 8 after "dnf update" + vagrant halt,reboot - can't login with vagrant, student

