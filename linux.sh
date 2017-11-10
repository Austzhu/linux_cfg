#!/bin/bash

TOPDIR=${PWD}
SOURCE_DIR=/etc/apt/sources.list.d

# google-chrome 源
sudo echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"	>\
${SOURCE_DIR}/google-chrome.list
# 搜狗拼音输入法
sudo echo "deb http://archive.ubuntukylin.com:10006/ubuntukylin xenial main"	>\
${SOURCE_DIR}/sogoupinyin.list
sudo echo "deb http://archive.ubuntu.com/ubuntu/ raring main restricted universe multiverse" >\
${SOURCE_DIR}/others.list

sudo apt-get update

login_root()
{
	local LOGIN_FILE=/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
	sudo echo "greeter-show-manual-login=true" >> ${LOGIN_FILE}
	sudo sed -i 's/mesg.*/tty -s && mesg n/' /root/.profile
}

install_soft()
{
	read -p "请输入安装软件包目录　"　soft_pathname
	echo "PATH: ${soft_pathname}"
	cd 　${soft_pathname}

	sudo dpkg -i *.deb
}

subl_conf()
{
	if [ -f ${TOPDIR}/subl-cfg/subl_install.sh ]; then
		cd ${TOPDIR}/subl-cfg/

		./subl_install.sh

		cd -
	fi
}

install_tftpboot()
{
	TFTP_DIR=/opt/tftpboot
	mkdir ${TFTP_DIR} -p
	chmod 777 ${TFTP_DIR} -R

	sudo apt-get install tftp-hpa tftpd-hpa xinetd -y

	sudo echo -e "#/etc/default/tftpd-hpa\n"	\
	"TFTP_USERNAME=\"tftp\"\n"		\
	"TFTP_DIRECTORY=\"${TFTP_DIR}\"\n"	\
	"TFTP_ADDRESS=\"0.0.0.0:69\"\n"		\
	"TFTP_OPTIONS=\"-l -c -s\"\n" > /etc/default/tftpd-hpa

	sudo echo -e "service tftp\n"		\
	"{\n"					\
	"	socket_type = dgram\n"		\
	"	wait = yes\n"			\
	"	disable = no\n"			\
	"	user = root\n"			\
	"	protocol = udp\n"		\
	"	server = /usr/sbin/in.tftpd\n"	\
	"	server_args = -s ${TFTP_DIR}\n"	\
	"	per_source = 11\n"		\
	"	cps =100 2\n"			\
	"	flags =IPv4\n"			\
	"}\n" > /etc/xinetd.d/tftp

	service tftpd-hpa restart
	/etc/init.d/xinetd reload
	/etc/init.d/xinetd restart
	/etc/init.d/tftpd-hpa restart
}

install_nfs()
{
	NFS_DIR=/opt/nfs
	mkdir -p ${NFS_DIR}
	chmod 777 -R ${NFS_DIR}

	sudo apt-get install nfs-kernel-server nfs-common -y

	echo "${NFS_DIR} *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
	showmount -e
	exportfs -r
	#showmount localhost -e
	/etc/init.d/nfs-kernel-server restart
}

install_others()
{
	INSTALL_SOFTS="vim okular meld git terminator sogoupinyin"
	INSTALL_SOFTS=${INSTALL_SOFTS}" openssh-server openssh-client ctags cscope"
	INSTALL_SOFTS=${INSTALL_SOFTS}" google-chrome-beta"

	# 安装menuconfig支持的库
	INSTALL_SOFTS=${INSTALL_SOFTS}" libncurses5-dev"

	# automake 工具,tslib需要
	INSTALL_SOFTS=${INSTALL_SOFTS}" autoconf automake libtool"

	# 64位系统兼容库
	INSTALL_SOFTS=${INSTALL_SOFTS}" lib32stdc++6 libglib2.0-0:i386 lib32z1 "
	INSTALL_SOFTS=${INSTALL_SOFTS}" lib32ncurses5 libgtk2.0-0:i386 lib32bz2-1.0"
	INSTALL_SOFTS=${INSTALL_SOFTS}" libxxf86vm1:i386 libsm6:i386 lib32stdc++6"
	INSTALL_SOFTS=${INSTALL_SOFTS}" libgl1-mesa-dev:i386 libexpat-dev:i386"
	INSTALL_SOFTS=${INSTALL_SOFTS}" libevent-openssl-2.0-5:i386 libreadline-dev:i386 liblzo2-2:i386"

	sudo dpkg --add-architecture i386
	sudo dpkg -S libgthread-2.0.so.0
	sudo apt install libc6:i386
	sudo locale-gen zh_CN.UTF-8

	for args in ${INSTALL_SOFTS}
	do
		echo "\nINSTALL: \033[31m ${args}...\033[0m\n"
		sudo apt-get install ${args} -y
	done

	# sudo apt-get install liblzo2-2:i386 --fix-missing
	export LC_CTYPE=zh_CN.UTF-8
}

read -p "是否要解决登陆不能登入root问题.  y?n  " flag
[ "$flag" == "y" -o "$flag" == "" ] && login_root


read -p "是否要安装相关软件.  y?n  " flag
[ "$flag" == "y" -o "$flag" == "" ] && install_soft


read -p "是否要解决sublime_text不能输入中文的问题.  y?n  " flag
[ "$flag" == "y" -o "$flag" == "" ] && subl_conf

read -p "是否要安装tftp.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ] && install_tftpboot


read -p "是否要安装nfs.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == ""  ] && install_nfs

read -p "安装其他软件  y?n  " flag
[ "$flag" == "y" -o "$flag" == "" ] &&　install_others

read -p "是否重启.  y?n  " flag
[ "$flag" == "y" ] && sudo reboot

exit 0
