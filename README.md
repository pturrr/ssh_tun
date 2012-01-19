Description
===========

This cookbook has 3 recipes. Following actions are performed:

[ssh]:

- EPEL yum repo enabled on redhat/centos/fedora becasue there is no autossh in standard repos
- autossh installed
- install script tunnels.sh to /usr/locals/sbin (it is not a service, just an script for working with tunnels)
- sample tunnels created upon installation(data taken from attributes)

[ssh::restart]:

- restart all tunnels

[ssh::stop]

- stop all tunnels


Requirements
============

- must be run under root
- root must have access to gateway host(with authorization by keys without passphrase)


Attributes
==========
Example:

node['tunnels']['tunX'] = "172.16.1.100 8080 80"


Usage
=====


Usage of tunnels script: ./tunnels.sh (add|stop|status|restart)

                        add) requires extra arguments:

                        remote ip address - address through which we will create tunnel
                        local port - to which port you will make requests locally
                        remote port - port you want to forward from remote site

                Example: ./tunnels.sh add 172.16.1.100 4040 8080

                        stop) - will stop all tunnels.

                        If you need to stop only one - use stop and output of status command

                Example: ./tunnels.sh stop 8080:localhost:80 root@172.16.1.100 will stop only this tunnel

                        restart) - will restart all currently running tunnels

                        status) - will show you all cuurently running tunnels


