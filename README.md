# Corteza Vagrant environment

Try and test Corteza on your own machine with Vagrant.

Please read https://www.vagrantup.com/intro/index.html if you
are not familiar with Vagrant.

## How to use?

1. Install vagrant - https://www.vagrantup.com/downloads.html
2. Install Virtualbox - https://www.virtualbox.org/wiki/Linux_Downloads
3. Run `vagrant up` (might take a couple of minutes, depending on internet connection speed and performance of your machine)
4. Last lines from provision process shows IP address where Corteza can be accessed
5. Sign up (first user created is automatically assigned to admin role)
6. Confirmation email will be intercepted by Mailhog (point your browser to `http://<vagrant-box-ip>/mailhog`) 
7. Click on the link and enjoy testing Corteza

### If you encounter this error during the 3rd step:
> A host only network interface you're attempting to configure via DHCP already has a conflicting host only adapter with DHCP enabled

Try running:
1. `VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0`
2. `vagrant destroy`
3. `vagrant up`

## Provision

See `setup/install.sh` for provision logic.  
Directory `setup/` also contains configuration files for all used components.

## Todo
 - [ ] Basic setup with ability to test Corteza on local machine
 - [ ] Can we use this w/o IP (hostname, /etc/hosts)?
 - [ ] Instructions on how to enable development mode
 - [ ] gRPC web UI for corredor
 - [ ] MySQL web UI
 
## Known bugs
 - [ ] Messaging and Compose cannot handle relative URLs for file attachments. Although file upload works, this bug prevents users from viewing the files

## Troubleshooting

Logs from supervisored services are accessible on mounted directory:
 - var/log/mailhog.log
 - var/log/server-api.log
 - var/log/server-corredor.log
 
Logs rotate after 2MB. See `setup/supervisor-*.conf` for details

 
Other logs, accessible inside vagrant machine (after `vagrant ssh`)
 - /var/log/supervisor/supervisord.log
 - /var/log/nginx/access.log
 - /var/log/nginx/error.log
 - /var/log/mysql/error.log
