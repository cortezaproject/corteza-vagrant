# Corteza Vagrant environment

Try and test Corteza on your own machine with Vagrant.

Please read https://www.vagrantup.com/intro/index.html if you
are not familiar with Vagrant.

## How to use?

1. `vagrant up` (might take a couple of minutes, depending on internet connection speed and performance of your machine)
2. Last lines from provision process shows IP address where Corteza can be accessed
3. Sign up (first user created is automatically assigned to admin role)
4. Confirmation email will be intercepted by Mailhog (point your browser to `http://<vagrant-box-ip>/mailhog`) 
5. Click on the link and enjoy testing Corteza

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
