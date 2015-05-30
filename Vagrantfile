# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.define :master do |master|
		master.vm.box = "chef/centos-7.0"
		master.vm.provider "vmware_fusion" do |v|
			v.vmx["memsize"]  = "2048"
			v.vmx["numvcpus"] = "2"
		end
		master.vm.provider "virtualbox" do |v|
		  v.name = "hadoop-yarn"
		  v.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
		end
		master.vm.network :private_network, ip: "10.211.55.101"
		master.vm.hostname = "hadoop-yarn"
		master.vm.provision :shell, path: 'setup.sh'
		master.vm.network "forwarded_port", guest: 50070, host: 50070
		master.vm.network "forwarded_port", guest: 50075, host: 50075
		master.vm.network "forwarded_port", guest: 8088, host: 8088
		master.vm.network "forwarded_port", guest: 8042, host: 8042
		master.vm.network "forwarded_port", guest: 8020, host: 8020
		master.vm.network "forwarded_port", guest: 8032, host: 8032
		master.vm.network "forwarded_port", guest: 19888, host: 19888
		master.vm.network "forwarded_port", guest: 10020, host: 10020
		master.vm.network "forwarded_port", guest: 50010, host: 50010
	end
end
