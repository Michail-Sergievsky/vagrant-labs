# -*- mode: ruby -*-
# vi: set ft=ruby :
# Russian repo for distro
ENV['VAGRANT_SERVER_URL'] = 'https://vagrant.elab.pro'

require 'fileutils'
require 'yaml'
hosts = YAML.load_file('hosts.yml')

# file operations needs to be relative to this file
VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))

# directory that will contain VDI files
VAGRANT_DISKS_DIRECTORY = "disks"

# controller definition
VAGRANT_CONTROLLER_NAME = "Virtual I/O Device SCSI controller"
VAGRANT_CONTROLLER_TYPE = "virtio-scsi"

# define disks
# The format is filename, size (GB), port (see controller docs)
local_disks = [
  { :filename => "disk1", :size => 5, :port => 5 },
  { :filename => "disk2", :size => 5, :port => 6 },
  { :filename => "disk3", :size => 5, :port => 25 }
]

#shell provisioning
  shell1 = <<-SHELL
        # Timezone configuration.
        timedatectl set-timezone Europe/Moscow
        
        # OS user configuration.
        USER=student
        GROUP="${USER}"
        PASSWORD="${USER}"
        useradd -m -s /bin/bash "${USER}"
        mkdir /home/"${USER}"/.ssh/
        mv /tmp/authorized_keys /home/"${USER}"/.ssh/
        chmod 700 /home/"${USER}"/.ssh/
        chmod 600 /home/"${USER}"/.ssh/*
        chown -R "${USER}":"${GROUP}" /home/"${USER}"/.ssh/
        usermod --password $(openssl passwd "${PASSWORD}") "${USER}"
        echo "%${USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}"
        su $USER -c "cp -f /tmp/.bashrc /home/$USER/"
        su $USER -c "cp -f /tmp/.bash_profile /home/$USER/"
        
        usermod --password $(openssl passwd rootpass) root
        # SSH configuration.
        sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config
        systemctl restart sshd
      SHELL

#creating vm
Vagrant.configure("2") do |config|
  hosts.each do |host|
    config.vm.define host['name'] do |machine|
      machine.vm.box = host['distrib']
      machine.vm.box_check_update = false
      machine.vm.box_version = host['vmversion']
      machine.vm.hostname = host['name']

      host["network"].each do |interface, parameters|
        machine.vm.network "private_network", 
        ip: parameters['ip'],
        netmask: parameters["netmask"]
      end

      # disks_directory = File.join(VAGRANT_ROOT, VAGRANT_DISKS_DIRECTORY)
      hostname = host['name']
      disks_directory = File.join(VAGRANT_ROOT, ".vagrant/machines", hostname, VAGRANT_DISKS_DIRECTORY)

      # create disks before "up" action
      machine.trigger.before :up do |trigger|
        trigger.name = "Create disks"
        trigger.ruby do
          unless File.directory?(disks_directory)
            FileUtils.mkdir_p(disks_directory)
          end
          local_disks.each do |local_disk|
            local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
            unless File.exist?(local_disk_filename)
              puts "Creating \"#{local_disk[:filename]}\" disk"
              system("vboxmanage createmedium --filename #{local_disk_filename} --size #{local_disk[:size] * 1024} --format VDI")
            end
          end
        end
      end

      # create storage controller on first run
      unless File.directory?(disks_directory)
        machine.vm.provider "virtualbox" do |storage_provider|
          storage_provider.customize ["storagectl", :id, "--name", VAGRANT_CONTROLLER_NAME, "--add", VAGRANT_CONTROLLER_TYPE, '--hostiocache', 'off']
        end
      end

      # attach storage devices
      machine.vm.provider "virtualbox" do |storage_provider|
        local_disks.each do |local_disk|
          local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
          unless File.exist?(local_disk_filename)
            storage_provider.customize ['storageattach', :id, '--storagectl', VAGRANT_CONTROLLER_NAME, '--port', local_disk[:port], '--device', 0, '--type', 'hdd', '--medium', local_disk_filename]
          end
        end
      end

      # cleanup after "destroy" action
      machine.trigger.after :destroy do |trigger|
        trigger.name = "Cleanup operation"
        trigger.ruby do
          # the following loop is now obsolete as these files will be removed automatically as machine dependency
          local_disks.each do |local_disk|
            local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
            if File.exist?(local_disk_filename)
              puts "Deleting \"#{local_disk[:filename]}\" disk"
              system("vboxmanage closemedium disk #{local_disk_filename} --delete")
            end
          end
          if File.exist?(disks_directory)
            FileUtils.rmdir(disks_directory)
          end
        end
      end
      
      machine.vm.provider :virtualbox do |v|
          v.gui = false
          v.memory = host['memory']
          v.cpus = host['cpus']
      end
      
      # Provisioning.
      machine.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/tmp/authorized_keys"
      machine.vm.provision "file", source: "files/.bash_profile", destination: "/tmp/.bash_profile"
      machine.vm.provision "file", source: "files/.bashrc", destination: "/tmp/.bashrc"
      machine.vm.provision "shell", inline: shell1

      # Centos8 repos
      if (host['os'] == "centos8") then
        machine.vm.provision "shell", inline: "sed -i -e 's|mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*"
        machine.vm.provision "shell", inline: "sed -i -e 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*"
      else
      end
      # Centos_intall_vim
      # HOW to make OR in YMAL????
      # if [[ (host['os'] == "centos7") || (host['os'] == "centos8") ]]then
      #   machine.vm.provision "shell", inline: "yum install vim -y"
      # else
      # end
      if (host['os'] == "centos7") then
        machine.vm.provision "shell", inline: "yum install vim -y"
      else
      end
      if (host['os'] == "centos8") then
        machine.vm.provision "shell", inline: "yum install vim -y"
      else
      end
      # Ubuntu update
      if (host['os'] == "ubuntu2004") then
        machine.vm.provision "shell", inline: "apt update"
      else
      end
    end
  end
end
