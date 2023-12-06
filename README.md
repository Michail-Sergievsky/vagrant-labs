# Vagrant

Russian repo for distro
https://vagrant.elab.pro

2 hosts - centos7
2 hosts - centos8
2 hosts - ubuntu2004

Every hosts has 4 partition:
1 - root partition 40 GB
3 more partition with 5 GB

Create remote user student

Send public ssh-key from user that create machines to student

Custom .bashrc, .bash_profile for student

Fixed Centos 8 repo

TO DO

Centos 8 after "dnf update" + vagrant halt,reboot - can't login with vagrant, student

## Команды vagrant используемые при работе с виртуальными машинами
```
vagrant up [VM_NAME] - развернуть виртуальную машину
vagrant halt [VM_NAME] - выключить виртуальную машину
vagrant suspend [VM_NAME] - перевести спящию машину в спящий режим 
vagrant resume [VM_NAME] - вывести машину из спящего режима
vagrant reload [VM_NAME] - перезагрузить машину
vagrant provision [VM_NAME] - запуск провижинга указанного в файле vagrantfile
vagrant destroy [VM_NAME] - удалить виртуальную машину
vagrant ssh [VM_NAME] - подключится к виртуальной машине через ssh
vagrant status - посмотреть состояние виртуальных машин
```
