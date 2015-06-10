# Introduction

This Vagrant project creates a VM with single node setup of Hadoop with YARN installed.

# Getting Started

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Run ```vagrant box add chef/centos-7.0```
4. Git clone this project, and change directory (cd) into this project (directory).
4. Edit ```setup.sh``` to set the version of Hadoop you want to install
5. Run ```vagrant up``` to create the VM.
6. Run ```vagrant ssh``` to get into your VM.
7. Run ```sudo -iu hduser``` once inside the VM to log in as the user who started hadoop.
8. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.

Some gotcha's.

1. Make sure you download Vagrant v1.4.3 or higher.
2. Make sure when you clone this project, you preserve the Unix/OSX end-of-line (EOL) characters. The scripts will fail with Windows EOL characters.
3. Defaults for the VM are 2GB of ram and 2 cpus. You may change the Vagrantfile to specify other requirements.
4. This project has NOT been tested with the VMWare provider for Vagrant.
5. You may change the script (setup.sh) to point to a different location for Hadoop to be downloaded from. Here is a list of mirrors: http://www.apache.org/dyn/closer.cgi/hadoop/common/.
6. The script automatically creates the hduser user and starts hadoop under its control.
7. A systemd service is provided to start and stop hadoop. It is enabled by default.
8. By default the script (setup.sh) install hadoop inside the /opt/hadoop directory. You may change this specifying another directory inside the HADOOP_HOME variable.

# Make the VM setup faster
You can make the VM setup even faster if you pre-download the Hadoop and Oracle JDK into the /resources directory.

1. /resources/hadoop-${HADOOP_VERSION}.tar.gz
2. /resources/jdk-8u45-linux-x64.gz

The setup script will automatically detect if these files (with precisely the same names) exist and use them instead. If you are using slightly different versions, you will have to modify the script accordingly.

# Web UI
You can check the following URLs to monitor the Hadoop daemons.

1. [NameNode] (http://localhost:50070/dfshealth.html)
3. [ResourceManager] (http://localhost:8088/cluster)

Note that you point your browser to "localhost" because when the VM is created, it is specified to perform port forwarding from your desktop to the VM.

# Vagrant boxes
A list of available Vagrant boxes is shown at http://www.vagrantbox.es.

# Vagrant box location
The Vagrant box is downloaded to the ~/.vagrant.d/boxes directory. On Windows, this is C:/Users/{your-username}/.vagrant.d/boxes.

# References
This project was kludge together with great pointers from all around the internet.

1. http://hadoop.apache.org/docs/r2.3.0/hadoop-project-dist/hadoop-common/ClusterSetup.html
2. http://wiki.apache.org/hadoop/BindException
3. https://www.centos.org/docs/5/html/5.1/Deployment_Guide/s1-server-ports.html
4. http://www.cyberciti.biz/faq/disable-linux-firewall-under-centos-rhel-fedora/
5. http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_11_2.html
6. http://blog.cloudera.com/blog/2009/08/hadoop-default-ports-quick-reference/
7. http://linuxgalaxy.com/make-life-easier-create-a-service-on-linux/
8. http://codingrecipes.com/service-x-does-not-support-chkconfig
9. http://linux.about.com/library/cmd/blcmdl8_chkconfig.htm
10. http://stackoverflow.com/questions/20901442/how-to-install-jdk-in-centos
11. http://serverfault.com/questions/119869/turning-off-cp-copy-commands-interactive-mode-cp-overwrite
12. http://askubuntu.com/questions/45349/how-to-extract-files-to-another-directory-using-tar-command

# Copyright Stuff
Copyright 2014 Jee Vang

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
