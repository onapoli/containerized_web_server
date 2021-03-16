# containerized_web_server
A Docker image for building a server that runs multiple services.

### PROJECT OBJECTIVE

Create a Docker image for running a multiservice container with an Nginx
web server, MySQL (MariaDB), PhpMyAdmin, and WordPress. 

### CONVENIENCE SCRIPTS GUIDE

These scripts are made for running in Unix Docker hosts. To execute them
with `./script_name.sh`, file execution permission must be granted to the
corresponding user and/or group. Scripts can also be executed with
`sh script_name.sh`, without needing to manage file permissions.

All Docker commands within the scripts are prepended by `sudo`. The Docker
daemon always runs as the root user, so other users will need to execute Docker
commands with `sudo` for being able to do it with the security privileges of
root.
There are ways to execute Docker commands without sudo, but the scripts were
written to be executed in as much environments as possible, so this
functionality was not expected.

1. BUILD IMAGE AND RUN CONTAINER
`./build_run_image.sh` OR `sh build_run_image.sh`

(OPTIONAL) TURN NGINX autoindex DIRECTIVE on
`./autoindex_on.sh` OR `sh autoindex_on.sh`

(OPTIONAL) TURN NGINX autoindex DIRECTIVE off
`./autoindex_off.sh` OR `sh autoindex_off.sh`

(OPTIONAL) LAUNCH AN INTERACTIVE TERMINAL INSIDE THE CONTAINER OS
`./interactive_terminal.sh` OR `sh interactive_terminal.sh`

2. STOP RUNNING CONTAINER
`./stop_container.sh` OR `sh stop_container.sh`

3. REMOVE UNUSED OR USELESS IMAGE DATA (USEFULL WHEN MODIFYING IMAGE)
`./remove_imgs_cnts.sh` OR `sh remove_imgs_cnts.sh`

DOCKER COMMAND INDEX

LIST IMAGES
`docker images`

LIST RUNNING CONTAINERS
`docker ps`

LIST ALL CONTAINERS THAT WE RAN
`docker ps -a`

STOP RUNNING CONTAINER
`docker stop container_id`

REMOVE CONTAINER
`docker rm container_id`

REMOVE ALL STOPPED CONTAINERS
`docker rm $(docker ps -a -q)` OR `docker container prune`

BUILD IMAGE
`docker build -t my_42_server .`

RUN CONTAINER
`docker run --rm --name my_container -d -p 8080:80 -p 8443:443 my_42_server`

REMOVE UNNECESARY IMAGE DATA
```shell
docker rmi `docker images --filter dangling=true -q`
```
