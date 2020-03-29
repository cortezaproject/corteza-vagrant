# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial64"
    

    # set the hostname
    config.vm.hostname = "mylocal.dev"

    #set the shared folder
    config.vm.synced_folder "src", "/home/vagrant/workspace/src"

    #provision the box
    config.vm.provision :shell, :path => "setup/install.sh"

    #Use a free ip from the same lan as the host
    config.vm.network "private_network", type: "dhcp"

    #port forwarding
    config.vm.network "forwarded_port", guest: 8085, host: 8085, auto_correct: true
    config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
    config.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true

end
