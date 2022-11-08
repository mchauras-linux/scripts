#! /bin/bash

if [ $# -lt 1 ]
then
	read -p "Provide brew build link of specific architecture: " link
else
	link=$1
fi

echo "Downloading rpm's from $link"

curl $link | grep download | awk '{print $2}' | sed 's/href="//' | sed 's/">/  /' | awk '{print $1}' > rpmLinks.txt

file=$(cat rpmLinks.txt)

mkdir -p RPMS
cd RPMS

rm -f *.rpm

for line in $file
do
	wget $line &	
done

cd ..

wait
