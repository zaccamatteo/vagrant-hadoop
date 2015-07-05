# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
config_file = "#{current_dir}/vagrant.yml"
custom_configs = { }
if File.file?(config_file)
	custom_configs = YAML.load_file(config_file)
end

Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.define :hdvm do |hdvm|
		hdvm.vm.box = "chef/centos-7.0"
		hdvm.vm.provider "vmware_fusion" do |v|
			v.vmx["memsize"]  = "2048"
			v.vmx["numvcpus"] = "4"
		end
		hdvm.vm.provider "virtualbox" do |v|
			v.name = "centos-7_hadoop"
			v.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "4"]
		end
		hdvm.vm.provision :shell, path: 'setup.sh'
		hdvm.vm.network "forwarded_port", guest: 50070, host: 50070
		hdvm.vm.network "forwarded_port", guest: 9000, host: 9000
		hdvm.vm.network "forwarded_port", guest: 8088, host: 8088
		hdvm.vm.network "forwarded_port", guest: 8032, host: 8032

		if not custom_configs.empty?
			synced_folder = custom_configs['synced_folder']
			hdvm.vm.synced_folder synced_folder['host'], synced_folder['guest'],
				create: synced_folder['create'],
				mount_options: [synced_folder['mount_options']]
		end
	end
end
