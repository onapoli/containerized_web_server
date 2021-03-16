#!/bin/bash
sudo docker exec my_container sed -i 's/autoindex on/autoindex off/g' \
/etc/nginx/sites-available/my_website.conf

sudo docker exec my_container nginx -s reload
