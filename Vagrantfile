# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial64"

    # Set the hostname
    config.vm.hostname = "corteza-devbox"

    # Use a free ip from the same lan as the host
    config.vm.network "private_network", type: "dhcp"

    # Provision the box
    config.vm.provision :shell, :path => "setup/install.sh"

    config.vm.provision "bootstrap", type: "shell", run: "always" do |s|
        # Shop IP every time the box is started
        s.inline = "echo -e \"Point your browser to:\nhttp://\"$(hostname -I | cut -d ' ' -f 2)"
    end
end
