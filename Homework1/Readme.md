# Homework 1

## 1.

### a.

` docker pull nginx:1.21.6 `

` docker pull nginx:1.21.6-alpine`

### b.
nginx:1.21.6 size: 141.51

nginx:1.21.6-alpine 23.43

The alpine is much smaller from nginx I believe this is because alpine is designed to run on docker and highly optimized to run there

### c.

` docker run -d  --name johnginx -p 80:80 nginx:1.21.6 `

`curl localhost:80 `

![nginx_index_html](Assets/1c_index_html.png)

### d.

`docker ps`

![docker_ps](Assets/1d_docker_ps.png)

### e.

`docker container logs johnginx`

![container_logs](Assets/1e_container_logs.png)

### f.

`docker stop johnginx`

### g.

`docker start johnginx`

### h.


`docker stop johnginx`

`docker rm johnginx`

## 2.

### a.

` docker run -d  --name johnginx -p 80:80 nginx:1.21.6 `

` docker exec -it johnginx bash `

` apt-get update `
` apt-get install nano`

` cd /usr/share/nginx/html`

![myindex_html](Assets/2a_myindex_html.png)

### b. 

`curl localhost:80 > index.html`

`cp test.html johnginx:/usr/share/nginx/html/index.html`

![2b_newindex_html](Assets/2b_newindex_html.png)


`docker stop johnginx`

`docker rm johnginx`

` docker run -d  --name johnginx -p 80:80 nginx:1.21.6 `

### c.
The changes are gone because this is a fresh image nothing has been saved from the old image.

## 3

`git clone --recurse-submodules https://github.com/chazapis/hy548.git`

`cd hy548/html`

`hugo -D`

`cd ..`

`docker cp public/. johnginx:/usr/share/nginx/html/ `

![3_hy548_index_html](Assets/3_hy548_index_html.png)


## 4

` docker run -d  --name john -p 80:80 nginx:1.21.6 `

Original Size: 1.12kB
New size: 154MB

` cd /usr/share/nginx/html `

`apt-get update `

`apt-get install hugo `

`apt-get install git`

`git clone --recurse-submodules https://github.com/chazapis/hy548.git `

`cd hy548/html/ `

`hugo -D`

`mv public/* /usr/share/nginx/html/.`

`cd ../../`

`rm -rf hy548 `

OR with the docker file we can do

`docker build -t "hy548:csdp1235" . `
`docker run -d  --name john -p 80:80 hy548:csdp1235`

To upload my image I did

`docker container commit d884cf8f11c2 johnarakas/hy548`

`docker image push johnarakas/hy548`

To pull

`docker pull johnarakas/hy548:latest`










