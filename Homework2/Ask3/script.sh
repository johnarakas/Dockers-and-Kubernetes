#!/bin/bash
apt-get update

apt-get install git -y

apt-get install curl -y

cd ../

git clone --recurse-submodules https://github.com/johnarakas/hy548


curl -L https://github.com/gohugoio/hugo/releases/download/v0.96.0/hugo_extended_0.96.0_Linux-64bit.deb -o hugo.deb


apt install ./hugo.deb

hugo version
 
cd  hy548

cd html

hugo -D

diff -q public/  /usr/share/nginx/html/ 1>/dev/null
if [[ $? == "0" ]]
then
  echo "The same"
else
  echo "Not the same"
  cp -r public/. /usr/share/nginx/html/
fi

ls -l

sleep infinity

