#!/bin/bash
sudo docker container prune -f
sudo docker rmi `sudo docker images --filter dangling=true -q`
