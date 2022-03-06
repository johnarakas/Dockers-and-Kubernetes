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

![nginx_index_html](https://github.com/johnarakas/CS-548/tree/main/Homework1/Assets/1c_index_html.png)

### d.

`docker ps`

![docker_ps](https://github.com/johnarakas/CS-548/tree/main/Homework1/Assets/1d_docker_ps.png)

### e.

`docker container logs johnginx`

![container_logs](https://github.com/johnarakas/CS-548/tree/main/Homework1/Assets/1e_container_logs.png)

### f.

`docker stop johnginx`

### g.

`docker start johnginx`

### h.


`docker stop johnginx`

`docker rm johnginx`

