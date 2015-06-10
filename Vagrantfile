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
			v.name = "centos-7_hadoop"
			v.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
		end
		master.vm.provision :shell, path: 'setup.sh'
		master.vm.network "forwarded_port", guest: 50070, host: 50070
		master.vm.network "forwarded_port", guest: 9000, host: 9000
		master.vm.network "forwarded_port", guest: 8088, host: 8088
	end
end
