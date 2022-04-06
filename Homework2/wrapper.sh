#!/bin/bash
apt-get update

apt-get install git -y

apt-get install curl -y

cd ../

git clone --recurse-submodules https://github.com/chazapis/hy548.git


curl -L https://github.com/gohugoio/hugo/releases/download/v0.96.0/hugo_extended_0.96.0_Linux-64bit.deb -o hugo.deb


apt install ./hugo.deb

hugo version
 
cd  hy548

cd html

hugo -D

ls -l

sleep infinity

