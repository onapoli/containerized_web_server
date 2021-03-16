#!/bin/bash
sudo docker build -t my_42_server .
sudo docker run --rm --name my_container -d -p 8080:80 -p 8443:443 my_42_server
