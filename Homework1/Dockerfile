FROM nginx:1.21.6

MAINTAINER Arakas Ioannis johnarkas679@gmail.com

RUN apt-get update  && \
    apt-get install -y hugo  && \
    apt-get install -y git

RUN cd /usr/share/nginx/html  &&\ 
    git clone --recurse-submodules https://github.com/chazapis/hy548.git &&\ 
    cd hy548/html &&\ 
    hugo -D

RUN mv /usr/share/nginx/html/hy548/html/public/* /usr/share/nginx/html/. 

RUN cd /usr/share/nginx/html &&\
    rm -rf hy548