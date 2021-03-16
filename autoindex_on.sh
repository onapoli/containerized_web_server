#!/bin/bash
sudo docker exec my_container sed -i 's/autoindex off/autoindex on/g' \
/etc/nginx/sites-available/my_website.conf

sudo docker exec my_container nginx -s reload
