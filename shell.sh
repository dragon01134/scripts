#!/bin/bash

#### This function will add public key in remote host
function add_keys()
{
	IP=0
	USER=''
	RSA_PUB_FILE=id_rsa.pub
	SSH_CONF_DIR=$HOME/.ssh
	if [ $# -eq 1 ]
	then
		IP=$1
		USER=root
	elif [ $# -eq 2 ]
	then
		IP=$1
		USER=$2
	else
		echo "Usages: add_keys <IP> {user_name} "
		echo "user_name is optonal if not present then bydefault 'root'"
		return
	fi
	if [ ! -f  $SSH_CONF_DIR/$RSA_PUB_FILE ]
	then
		echo "Public key is not there !! Create a Key Pair"
		echo -n "Do you want to create one now(y/n):"
		read ans
		if [  "$ans" = "Y"  -o  "$ans" = "y"  ]
		then
			ssh-keygen -t rsa
		else
			return
		fi
	fi
	ssh $USER@$IP mkdir -p .ssh
	cat $SSH_CONF_DIR/$RSA_PUB_FILE | ssh $USER@$IP 'cat >> .ssh/authorized_keys'
}


#Added only for builder

funtion uxtreme()
{
	IP=''
	USER=''
	if [ $# -eq 1 ]
	then
		IP=$1
		USER="root"
	elif [ $# -eq 2]
	then
		IP=$1
		USER=$2
	else
		echo "Usages: uxtreme <IP> {<user>}"
		return
	fi
	
	scp xtremed/xtremed $USER@$IP:/var/log/updates/
	ssh $USER@$IP 'bash -s' "rw;mv -f /var/log/updates/xtremed /usr/sbin/xtremed ;cleanlogs ;sre"	
}

