FROM nginx:1.21.6-alpine

MAINTAINER Arakas Ioannis johnarkas679@gmail.com
    # installing the packages tha I need
RUN apk add hugo &&\
    apk add git &&\
    # cloning the project
    cd /usr/share/nginx/html  &&\ 
    git clone --recurse-submodules https://github.com/chazapis/hy548.git &&\ 
    cd hy548/html &&\ 
    # to build the project
    hugo -D &&\ 
    # overwrite the old image with new one
    mv /usr/share/nginx/html/hy548/html/public/* /usr/share/nginx/html/.  &&\ 
    # to remove the packages
    apk del hugo  &&\ 
    apk del git