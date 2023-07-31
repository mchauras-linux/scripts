#! /bin/bash

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
	sudo rm -rf /etc/yum.repos.d/$FILE
	echo "cleanup"
}

ID=$(head -n 1 $FILE | sed 's/^.//' | sed 's/.$//')

echo $ID
sudo mv $FILE /etc/yum.repos.d/

dnf reposync --repoid $ID

tar czvf $ID.tar.gz $ID

trap cleanup EXIT
