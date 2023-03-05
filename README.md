# IoT
Inception of Things (School21/Ecole42 project)

- ssh
- virtualbox
- vagrant

sudo apt update
sudo apt upgrade

sudo apt install qemu qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils

sudo apt install vagrant ruby-libvirt ebtables dnsmasq libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev

sudo systemctl enable libvirtd
sudo systemctl start libvirtd

sudo adduser $USER libvirt

https://app.vagrantup.com/centos/boxes/7/versions/2004.01/providers/virtualbox.box
https://app.vagrantup.com/centos/boxes/7/versions/2004.01/providers/libvirt.box

vagrant plugin install vagrant-scp --plugin-clean-sources --plugin-source https://rubygems.org
vagrant plugin install vagrant-libvirt --plugin-clean-sources --plugin-source https://rubygems.org

scp -P 2222 virtualbox.box sclam@localhost:~/.
scp -r -P 2222 IoT sclam@localhost:~/.

sudo vagrant up --provider=libvirt --no-parallel