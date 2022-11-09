#! /bin/bash

if [ ! -e ~/mchauras ]
then
	mkdir -p ~/mchauras
	file=`which $0`
	cp $file ~/mchauras/
	cd ~/mchauras/
fi

rsync -avh --progress ~/mchauras/ mchauras@ausgsa.ibm.com:/projects/l/ltc-redhat-voe/mchauras
