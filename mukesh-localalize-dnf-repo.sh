#! /bin/bash

if [ "$EUID" -ne 0 ]
then 
	echo "Please run as root"
	sudo $0 $1
	exit -1
fi

if [ $# -ne 1 ]; 
then 
	echo "Illegal number of parameters"
	echo "Usage: "
	echo "script <url of repo file>"
	exit -2
fi

FILE=`basename $1`
wget $1

cleanup() {
	rm -rf /etc/yum.repos.d/$FILE
	echo "cleanup"
}

ID=$(head -n 1 $FILE | sed 's/^.//' | sed 's/.$//')

echo $ID

mv $FILE /etc/yum.repos.d/

dnf reposync --repoid $ID

tar czvf $ID.tar.gz $ID

trap cleanup EXIT
