#!/bin/bash -x
JAVA_HOME=/usr/local/java
JAVA_ARCHIVE=jdk-8u45-linux-x64.tar.gz
HADOOP_HOME=/opt/hadoop
HADOOP_GROUP="hadoop"
HADOOP_USER="hduser"
HDUSER_HOME="/home/${HADOOP_USER}"
HADOOP_VERSION=2.7.0
HADOOP_ARCHIVE=hadoop-${HADOOP_VERSION}.tar.gz
HADOOP_MIRROR_DOWNLOAD=http://apache.miloslavbrada.cz/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

function fileExists {
	FILE=/vagrant/resources/$1
	if [ -e $FILE ]; then
		return 0
	else
		return 1
	fi
}

function disableFirewallAndIpv6 {
	echo "disabling firewall"
	systemctl disable firewalld
	systemctl stop firewalld
	echo "disabling ipv6"
	sysctl -w net.ipv6.conf.all.disable_ipv6=1
	sysctl -w net.ipv6.conf.default.disable_ipv6=1
	sysctl -w net.ipv6.conf.lo.disable_ipv6=1
}

function installHadoop {
	if fileExists $HADOOP_ARCHIVE; then
		installLocalHadoop
	else
		installRemoteHadoop
	fi
}

function installJava {
	if fileExists $JAVA_ARCHIVE; then
		installLocalJava
	else
		installRemoteJava
	fi
}

function installLocalJava {
	echo "installing oracle jdk"
	FILE=/vagrant/resources/$JAVA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteJava {
	echo "install open jdk"
	yum install -y java-1.8.0-openjdk-devel
}

function installLocalHadoop {
	echo "install hadoop from local file"
	FILE=/vagrant/resources/$HADOOP_ARCHIVE
	tar -xzf $FILE -C /opt
	echo "here is hadoop stuff"
	ls /opt
}

function installRemoteHadoop {
	echo "install hadoop from remote file"
	curl -o /home/vagrant/hadoop-${HADOOP_VERSION}.tar.gz -O -L $HADOOP_MIRROR_DOWNLOAD
	tar -xzf /home/vagrant/hadoop-${HADOOP_VERSION}.tar.gz -C /opt
}

function setupJava {
	echo "setting up java"
	if fileExists $JAVA_ARCHIVE; then
		ln -s /usr/local/jdk1.8.0_45 /usr/local/java
	else
		ln -s /usr/lib/jvm/jre /usr/local/java
	fi
}

function setupHadoop {
	ln -s /opt/hadoop-${HADOOP_VERSION} ${HADOOP_HOME}
	chmod 777 ${HADOOP_HOME}
	echo "creating hadoop group and hduser user"
	groupadd ${HADOOP_GROUP}
	useradd -g ${HADOOP_GROUP} ${HADOOP_USER}
	sudo -u ${HADOOP_USER} ln -s /hadoop-shared /home/${HADOOP_USER}/shared
	sudo -u ${HADOOP_USER} mkdir ${HDUSER_HOME}/.ssh
	sudo -u ${HADOOP_USER} ssh-keygen -t rsa -f ${HDUSER_HOME}/.ssh/id_rsa -P ""
	sudo -u ${HADOOP_USER} cat ${HDUSER_HOME}/.ssh/id_rsa.pub >> ${HDUSER_HOME}/.ssh/authorized_keys
	sudo -u ${HADOOP_USER} ssh-keyscan -H localhost >> ${HDUSER_HOME}/.ssh/known_hosts
	sudo -u ${HADOOP_USER} ssh-keyscan -H 0.0.0.0 >> ${HDUSER_HOME}/.ssh/known_hosts
	echo "copying over hadoop configuration files"
	cp -f /vagrant/resources/conf/* ${HADOOP_HOME}/etc/hadoop
	echo "modifying permissions on local file system"
	mkdir ${HADOOP_HOME}/logs
	chown -fR ${HADOOP_USER}:${HADOOP_GROUP} /opt/hadoop-${HADOOP_VERSION}/
}

function setupEnvVars {
	echo "setting up java environment variables"
	echo export JAVA_HOME=${JAVA_HOME} >> /etc/profile.d/java.sh
	echo export PATH=\${PATH}:\${JAVA_HOME}/bin >> /etc/profile.d/java.sh
	source /etc/profile.d/java.sh
	echo "setting up hadoop environment variables"
	echo export HADOOP_HOME=${HADOOP_HOME} >> /etc/profile.d/hadoop.sh
	echo export PATH=\${PATH}:\${HADOOP_HOME}/bin >> /etc/profile.d/hadoop.sh
	source /etc/profile.d/hadoop.sh
}

function setupNameNode {
	echo "setting up namenode"
	sudo -Eu ${HADOOP_USER} ${HADOOP_HOME}/bin/hdfs namenode -format
}

function setupHadoopService {
	echo "setting up hadoop service"
	cp -f /vagrant/resources/hadoop.service /etc/systemd/system/
	echo JAVA_HOME=${JAVA_HOME} >> /etc/systemd/system/hadoop.conf
	echo HADOOP_HOME=${HADOOP_HOME} >> /etc/systemd/system/hadoop.conf
}

function startHadoopService {
	echo "starting hadoop service"
	systemctl enable hadoop.service
	systemctl start hadoop.service
}

function initHdfsDirs {
	sudo -Eu ${HADOOP_USER} ${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /user/${HADOOP_USER}
}

disableFirewallAndIpv6
installJava
installHadoop
setupJava
setupHadoop
setupEnvVars
setupNameNode
setupHadoopService
startHadoopService
initHdfsDirs
