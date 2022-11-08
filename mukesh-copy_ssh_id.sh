#! /bin/bash

hostname=$1

read -p "Enter User name: " user
user=${user:-root}

echo $user

if [ -z "$hostname" ]
then
	read -p "Enter hostname of system to copy your ssh id: " hostname
fi

copy_id=$user@$hostname

echo -e "Are you sure you want to copy the ssh id to:\n$copy_id"
read -p "[y/n]" confirm
if [ "$confirm" = "y" ]
then
	ssh-copy-id -i ~/.ssh/id_rsa.pub $copy_id
	echo "SSH id copied"
else
	echo "Not Copying SSH id"
fi
